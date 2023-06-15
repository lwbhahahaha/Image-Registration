### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

# ╔═╡ 02f7a4c0-0731-11ee-2d14-a3bdb13bfe77
# Run with Julia 1.9.1
begin
	isdir("../input") || mkdir("../input")
	isdir("../input/reference_acq/") || mkdir("../input/reference_acq/")
	isdir("../input/with_motion") || mkdir("../input/with_motion")
	isdir("../output") || mkdir("../output")
	isdir("temp_files") || mkdir("temp_files")
	using Pkg
	Pkg.activate(raw".\libs")
	Pkg.instantiate()
	using NIfTI
	using DICOM
	using MAT
end;

# ╔═╡ 88406ea4-0432-42a2-8941-ebd2e95d7833
"""
	This function reads all DICOM pixel values given paths.
"""
function read_DICOM_pixel_values(found_limb_dcm, num_slice_v1, path_to_DICOM_folder, path_to_Limb_dcm_folder)
	v1_dir = joinpath(path_to_DICOM_folder, "01/")
	v2_dir = joinpath(path_to_DICOM_folder, "02/")
	curr_v1_dicom = Array{Int16, 3}(undef, num_slice_v1, 512, 512)
	curr_v2_dicom = Array{Int16, 3}(undef, num_slice_v1, 512, 512)
	curr_limb_dicom = found_limb_dcm ? Array{Int16, 3}(undef, num_slice_v1, 512, 512) : nothing
	got_error = false
	Threads.@threads for i = 1 : num_slice_v1
		v1_dicom_path = joinpath(v1_dir, "$i.dcm")
		v2_dicom_path = joinpath(v2_dir, "$i.dcm")
		limb_dicom_path = joinpath(path_to_Limb_dcm_folder, "CT"*string(999999+i)[2:end]*".dcm")
		
		try
			curr_v1_dicom[i, :, :] = dcm_parse(v1_dicom_path)[(0x7fe0, 0x0010)]
		catch e
			printstyled(" ERROR: Corrupted file \"$v1_dicom_path\".\n"; color = :red, bold = true)
			got_error = true
			break
		end
		
		try
			curr_v2_dicom[i, :, :] = dcm_parse(v2_dicom_path)[(0x7fe0, 0x0010)]
		catch e
			printstyled(" ERROR: Corrupted file \"$v2_dicom_path\".\n"; color = :red, bold = true)
			got_error = true
			break
		end
		
		if found_limb_dcm
			try
				curr_limb_dicom[i, :, :] = dcm_parse(limb_dicom_path)[(0x7fe0, 0x0010)]	
			catch e
				printstyled(" ERROR: Corrupted file \"$limb_dicom_path\".\n"; color = :red, bold = true)
				got_error = true
				break
			end
		end
		got_error && break
	end
	return got_error, curr_v1_dicom, curr_v2_dicom, curr_limb_dicom
end

# ╔═╡ 7aaec061-33d5-405a-a715-95d84bb54ef6
"""
	This function finds BB if `limb_dcm` is present for the current study.
"""
function find_BB(curr_limb_dicom, l; offset = 50)
	curr_limb_dicom == nothing && return
	up, down, left, right = nothing, nothing, nothing, nothing
	# top to buttom
	for x = 1 : 512
		up==nothing || break
		for slice_idx = 1 : l
			Threads.@threads for y = 1 : 512
				curr_limb_dicom[slice_idx, x, y] == -1024 || (up=x;break)
			end
			up==nothing || break
		end
	end
	# buttom to top
	for x = 512 : -1 : 1
		down==nothing || break
		for slice_idx = 1 : l
			Threads.@threads for y = 1 : 512
				curr_limb_dicom[slice_idx, x, y] == -1024 || (down=x;break)
			end
			down==nothing || break
		end
	end
	# left to right
	for y = 1 : 512
		left==nothing || break
		for slice_idx = 1 : l
			Threads.@threads for x = 1 : 512
				curr_limb_dicom[slice_idx, x, y] == -1024 || (left=y;break)
			end
			left==nothing || break
		end
	end
	# right to left
	for y = 512 : -1 : 1
		right==nothing || break
		for slice_idx = 1 : l
			Threads.@threads for x = 1 : 512
				curr_limb_dicom[slice_idx, x, y] == -1024 || (right=y;break)
			end
			right==nothing || break
		end
	end
	return [max(1, up-offset), min(512, down+offset), max(1, left-offset), min(512, right+offset)]
end

# ╔═╡ 7ac6631f-9620-436d-8dea-a48783d9af27
"""
 	This function deals with the file system and locate acquisitions.
"""
function Locate_images()
	# reference acquisition
	println("Step 1: Locating the reference acquisition...")
	study_names = readdir("../input/reference_acq/")
	if size(study_names)[1] < 1
		printstyled("\tERROR: Reference study not found!\n"; color = :red, bold = true)
		return nothing, nothing
	elseif size(study_names)[1] > 1
		printstyled("\tERROR: Found more than one reference studies!\n"; color = :red, bold = true)
		return nothing, nothing
	end
	println("\t1 Study found.")
	study_name = study_names[1]
	path_to_DICOM_folder = joinpath("../input/reference_acq/", study_name, "DICOM/")
	if !isdir(path_to_DICOM_folder)
		# 2 or more ACQs
		printstyled("\tERROR: Found more than one reference acquisition!\n"; color = :red, bold = true)
		return nothing, nothing
	end
	# Only 1 ACQ
	printstyled("\t\t$study_name:"; color = :yellow, bold = true)
	print(" 1 acquisition found.")
	path_to_v1_folder = joinpath(path_to_DICOM_folder, "01/")
	num_slice_v1 = size(readdir(path_to_v1_folder))[1]
	num_slice_v2 = size(readdir(path_to_v1_folder))[1]
	if num_slice_v1 != num_slice_v2
		printstyled("\n\t\tERROR: slice numbers of v1 and v2 are not same!\n"; color = :red, bold = true)
		return nothing, nothing
	end
	
	# Read all DICOM images
	got_error, curr_v1_dicom, curr_v2_dicom, _ = read_DICOM_pixel_values(false, num_slice_v1, path_to_DICOM_folder, "")
	if got_error
		println("\t\tError occured. Exiting...")
		return nothing, nothing
	end
	ref = (study_name, num_slice_v1, curr_v1_dicom, curr_v2_dicom)

	# with-motion acquisition(s)
	ct = 0
	with_motion = []
	println("\n\nStep 2: Locating with-motion acquisition(s)...")
	study_names = readdir("../input/with_motion/")
	for (i,study_name) in enumerate(study_names)
		print("\t$i. Study found: ")
		printstyled("$study_name\n"; color = :yellow, bold = true)
		path_to_DICOM_folder = joinpath("../input/with_motion/", study_name, "DICOM/")
		if isdir(path_to_DICOM_folder)
			# Only 1 ACQ
			print("\t\t1 acquisition found.")
			ct += 1
			path_to_v1_folder = joinpath(path_to_DICOM_folder, "01/")
			num_slice_v1 = size(readdir(path_to_v1_folder))[1]
			num_slice_v2 = size(readdir(path_to_v1_folder))[1]
			if num_slice_v1 != num_slice_v2
				printstyled("\n\t\tERROR: slice numbers of v1 and v2 are not same!\n"; color = :red, bold = true)
				continue
			end
			path_to_Limb_dcm_folder = joinpath("../input/with_motion/", study_name, "Segment_dcm/Limb_dcm/")
			found_limb_dcm = isdir(path_to_Limb_dcm_folder)&&size(readdir(path_to_Limb_dcm_folder))[1]==num_slice_v1 ? true : false
			
			# Read all DICOM images
			got_error, curr_v1_dicom, curr_v2_dicom, curr_limb_dicom = read_DICOM_pixel_values(found_limb_dcm, num_slice_v1, path_to_DICOM_folder, path_to_Limb_dcm_folder)
			if got_error
				println("\t\tError occured. Skipping this acquisition...")
				ct -= 1
				continue
			end
			
			# Get BB if limb_dcm is found
			BB = find_BB(curr_limb_dicom, num_slice_v1)
			
			push!(with_motion, [study_name, "", num_slice_v1, curr_v1_dicom, curr_v2_dicom, BB])
			if found_limb_dcm
				println(" Limb_dcm for this study is found.")
			else
				println(" Limb_dcm for this study is not found.")
			end
		else
			# 2 or more ACQs
			ACQs = readdir(joinpath("../input/with_motion/", study_name))
			println("\t\t$(size(ACQs)[1]) acquisitions found...")
			ct += size(ACQs)[1]
			for acq in ACQs
				print("\t\t\t$acq:")
				path_to_DICOM_folder = joinpath("../input/with_motion/", study_name, acq, "DICOM/")
				
				found_limb_dcm = false
				path_to_v1_folder = joinpath(path_to_DICOM_folder, "01/")
				num_slice_v1 = size(readdir(path_to_v1_folder))[1]
				num_slice_v2 = size(readdir(path_to_v1_folder))[1]
				if num_slice_v1 != num_slice_v2
					printstyled("\n\t\t\tERROR: slice numbers of v1 and v2 are not same!\n"; color = :red, bold = true)
					continue
				end
				path_to_Limb_dcm_folder = joinpath("../input/with_motion/", study_name, acq, "Segment_dcm/Limb_dcm/")
				found_limb_dcm = isdir(path_to_Limb_dcm_folder)&&size(readdir(path_to_Limb_dcm_folder))[1]==num_slice_v1 ? true : false
				
				# Read all DICOM images
				got_error, curr_v1_dicom, curr_v2_dicom, curr_limb_dicom = read_DICOM_pixel_values(found_limb_dcm, num_slice_v1, path_to_DICOM_folder, path_to_Limb_dcm_folder)
				if got_error
					println("\t\t\tError occured. Skipping this acquisition...")
					ct -= 1
					continue
				end
				
				# Get BB is limb_dcm is found
				BB = find_BB(curr_limb_dicom, num_slice_v1)
				
				push!(with_motion, [study_name, acq, num_slice_v1, curr_v1_dicom, curr_v2_dicom, BB])
				if found_limb_dcm
					println(" Limb_dcm for this study is found.")
				else
					println(" Limb_dcm for this study is not found.")
				end
			end
		end
	end
	println("\tFound $ct with-motion acquisition(s).")
	return with_motion, ref
end

# ╔═╡ 62bd5ffc-b0db-403d-9f9e-06ae848ae0dc
"""
	This function crops images based on `BB` and convert to nifty.
"""
function crop_and_convert2nifty(with_motion, ref)
	ref_study_name, ref_num_slice, ref_v1_dicom, ref_v2_dicom = ref
	for (i, curr_acq) in enumerate(with_motion)
		(study_name, acq, num_slice, v1_dicom, v2_dicom, BB) = curr_acq
		# created path to save
		isdir("temp_files") || mkdir("temp_files")
		temp_dir = joinpath("temp_files", study_name)
		isdir(temp_dir) || mkdir(temp_dir)
		temp_dir = joinpath(temp_dir, acq)
		isdir(temp_dir) || mkdir(temp_dir)
		ref_dir = joinpath(temp_dir, "ref")
		isdir(ref_dir) || mkdir(ref_dir)
		with_motion_dir = joinpath(temp_dir, "with_motion")
	    isdir(with_motion_dir) || mkdir(with_motion_dir)
		if BB != nothing
			up, down, left, right = BB
			# crop
			v1_dicom_cropped = v1_dicom[:, up:down, left:right]
			v2_dicom_cropped = v2_dicom[:, up:down, left:right]
			ref_v1_dicom_cropped = ref_v1_dicom[:, up:down, left:right]
			ref_v2_dicom_cropped = ref_v2_dicom[:, up:down, left:right]
			# save
			niwrite(joinpath(with_motion_dir, "v1.nii"), NIfTI.NIVolume(v1_dicom_cropped))
			niwrite(joinpath(with_motion_dir, "v2.nii"), NIfTI.NIVolume(v2_dicom_cropped))
			niwrite(joinpath(ref_dir, "v1.nii"), NIfTI.NIVolume(ref_v1_dicom_cropped))
			niwrite(joinpath(ref_dir, "v2.nii"), NIfTI.NIVolume(ref_v2_dicom_cropped))
		else
			# save
			niwrite(joinpath(with_motion_dir, "v1.nii"), NIfTI.NIVolume(v1_dicom))
			niwrite(joinpath(with_motion_dir, "v2.nii"), NIfTI.NIVolume(v2_dicom))
			niwrite(joinpath(ref_dir, "v1.nii"), NIfTI.NIVolume(ref_v1_dicom))
			niwrite(joinpath(ref_dir, "v2.nii"), NIfTI.NIVolume(ref_v2_dicom))
		end
		# free memory
		with_motion[i][4] = nothing 
		with_motion[i][5] = nothing 
	end
end

# ╔═╡ 872ca460-4525-48f5-a1d8-2be83633665c
"""
	This function wraps NiftyReg.
"""
function ApplyNiftyReg(with_motion)
	println("\nStep 3: Running registration...")
	flush(stdout)
	niftyReg_bin_path = joinpath("libs", "niftyReg","nift_reg_app","bin")
	aladin_path = abspath(joinpath(niftyReg_bin_path,"reg_aladin.exe"))
	f3d_path = abspath(joinpath(niftyReg_bin_path,"reg_f3d.exe"))
	
	for (study_name, acq, num_slice, v1_dicom, v2_dicom, BB) in with_motion
		printstyled("\t$study_name$(acq == "" ? "" : "_$acq")"; color = :yellow, bold = true)
		println(":")
		flush(stdout)
		temp_path = joinpath("temp_files", study_name, acq)
		ref_v1_nii_path = abspath(joinpath(temp_path, "ref", "v1.nii"))
		ref_v2_nii_path = abspath(joinpath(temp_path, "ref", "v2.nii"))
		motion_v1_nii_path = abspath(joinpath(temp_path, "with_motion", "v1.nii"))
		motion_v2_nii_path = abspath(joinpath(temp_path, "with_motion", "v2.nii"))
		aff_v1_out_path = abspath(joinpath(temp_path, "aff_v1.txt"))
		aff_v2_out_path = abspath(joinpath(temp_path, "aff_v2.txt"))
		aladin_v1_out_path = abspath(joinpath(temp_path, "aladin_v1.nii"))
		aladin_v2_out_path = abspath(joinpath(temp_path, "aladin_v2.nii"))
		cpp_v1_out_path = abspath(joinpath(temp_path, "cpp_v1.nii"))
		cpp_v2_out_path = abspath(joinpath(temp_path, "cpp_v2.nii"))
		
		f3d_v1_out_path = abspath(joinpath(temp_path, "registered_v1.nii"))
		f3d_v2_out_path = abspath(joinpath(temp_path, "registered_v2.nii"))
		
		# aladin first
		v1_aladin_command = `$aladin_path -ref "$ref_v1_nii_path" -flo "$motion_v1_nii_path" -aff "$aff_v1_out_path" -res "$aladin_v1_out_path"`
		v2_aladin_command = `$aladin_path -ref "$ref_v2_nii_path" -flo "$motion_v2_nii_path" -aff "$aff_v2_out_path" -res "$aladin_v2_out_path"`
		println("\t\tRunning aladin...")
		flush(stdout)
		isfile(aff_v1_out_path) || (run(v1_aladin_command);)
		isfile(aff_v2_out_path) || (run(v2_aladin_command);)
		
		# then f3d
		v1_f3d_command = `$f3d_path -ref "$ref_v1_nii_path" -flo "$motion_v1_nii_path" -aff "$aff_v1_out_path" -res "$f3d_v1_out_path" -cpp "$cpp_v1_out_path"`
		v2_f3d_command = `$f3d_path -ref "$ref_v2_nii_path" -flo "$motion_v2_nii_path" -aff "$aff_v2_out_path" -res "$f3d_v2_out_path" -cpp "$cpp_v2_out_path"`
		println("\t\tRunning f3d...")
		flush(stdout)
		isfile(cpp_v1_out_path) || (run(v1_f3d_command);)
		isfile(cpp_v2_out_path) || (run(v2_f3d_command);)

		# delete aladin
		isfile(aladin_v1_out_path) && (rm(aladin_v1_out_path);)
		isfile(aladin_v2_out_path) && (rm(aladin_v2_out_path);)
	end
end

# ╔═╡ 581b8144-1857-446a-94a8-8f58031574e1
"""
	This function corrects the orientation of images and save them.
"""
function postprocess_and_save(with_motion)
	println("\nStep 4: Post-processing...")
	flush(stdout)
	for (study_name, acq, num_slice, _, _, BB) in with_motion

		print("\tSaving ")
		printstyled("$study_name$(acq == "" ? "" : "_$acq")"; color = :yellow, bold = true)
		println("...")
		temp_path = joinpath("../output", study_name)
		isdir(temp_path) || mkdir(temp_path)
		temp_path = joinpath(temp_path, acq)
		isdir(temp_path) || mkdir(temp_path)

		
		f3d_v1_out_path = joinpath("temp_files", study_name, acq, "registered_v1.nii")
		f3d_v2_out_path = joinpath("temp_files", study_name, acq, "registered_v2.nii")
		v1 = niread(f3d_v1_out_path)
		v2 = niread(f3d_v2_out_path)

		# correct orientation
		v1 = permutedims(v1, [3, 2, 1])
		v2 = permutedims(v2, [3, 2, 1])
		
		# save as .mat
		matwrite(joinpath(temp_path, "01.mat"), Dict("imStack" => v1));
		matwrite(joinpath(temp_path, "02.mat"), Dict("imStack" => v2));
		
		# save as NIFTY
		niwrite(joinpath(temp_path, "01.nii"), NIfTI.NIVolume(v1))
		niwrite(joinpath(temp_path, "02.nii"), NIfTI.NIVolume(v2))
		
		# save as DICOM
		# will be implemented later
	end
end

# ╔═╡ 159c255c-41a8-4934-9509-00ad380fdc88
"""
	This function wraps all functions above.
"""
function run_reg()
	with_motion, ref = Locate_images()
	if with_motion == nothing || with_motion == []
		println("Exiting...")
		return
	end
	crop_and_convert2nifty(with_motion, ref)
	ref = nothing
	ApplyNiftyReg(with_motion)
	postprocess_and_save(with_motion)
	with_motion = nothing
	println("\n Done!")
end

# ╔═╡ Cell order:
# ╠═02f7a4c0-0731-11ee-2d14-a3bdb13bfe77
# ╟─88406ea4-0432-42a2-8941-ebd2e95d7833
# ╟─7aaec061-33d5-405a-a715-95d84bb54ef6
# ╟─7ac6631f-9620-436d-8dea-a48783d9af27
# ╟─62bd5ffc-b0db-403d-9f9e-06ae848ae0dc
# ╟─872ca460-4525-48f5-a1d8-2be83633665c
# ╟─581b8144-1857-446a-94a8-8f58031574e1
# ╟─159c255c-41a8-4934-9509-00ad380fdc88
