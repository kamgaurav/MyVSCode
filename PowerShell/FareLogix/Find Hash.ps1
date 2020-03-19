$file = 'C:\Users\gauravkam\Sys\xubuntu-19.04-desktop-amd64.iso'
%{get-Filehash -Algorithm md5 -Path $file ; get-FileHash -Algorithm sha1 -Path $file} | format-list
Compare-Object 0ce7ed9f0664be5df686f8a85d054915 0CE7ED9F0664BE5DF686F8A85D054915
Compare-Object 6EC3D369C06906E24E38F8BD6AA639BF71A11923 6ec3d369c06906e24e38f8bd6aa639bf71a11923