%%  Make WPT tracking video for AtlantikSolar ICRA Paper

uav_path = InspectionDataset_GS.uav_path;


%%
cnt = 1;
for i = 1:4:120
    max_dist_from_poly = .000118*10^6;%[];
    sparsify_factor = 500 - cnt*15;
    plot_results = Plot_PCL_wPath_simplified(InspectionDataset_GS.PointCloud_nrml(1:sparsify_factor:end,:),InspectionDataset_GS.PointCloud_offset,InspectionDataset_GS.uav_ref_dense,InspectionDataset_GS.uav_ref_sparse,uav_path(1:i,1:3),InspectionDataset_GS.BoundingPolygon,max_dist_from_poly)
%     set(gcf,'units','normalized','outerposition',[0 0 1 1])
    export_fig(['rcnstr_video_images_' num2str(cnt) '.png'],'-a2','-transparent','-png');%,'-m2','-transparent')
    cnt = cnt + 1;
end