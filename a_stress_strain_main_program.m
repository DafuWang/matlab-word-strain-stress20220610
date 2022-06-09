% %%%%%%%%%%%%%%%%%%%%%%%%%%%应力应变数据处理%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clc
tic
clear
%% %%%%%%%%%%%%%%%%%%%%%%%%%原始数据文件名和地址输入%%%%%%%%%%%%%%%%%%%%%%%%%
filename='C30-1SD2-2-24M';
fileadress=strcat('D:\大论文\应力-应变数据\24M\',filename);
N=2;%需修改，1:绝对时间，2:相对时间%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filespec_user = (strcat('D:\大论文\大论文\第七章\应力应变数据报告\',filename,'.doc'));% 设定测试Word文件名和路径
[Word,Document,Content,Selection]=word_active_and_open(filespec_user);%word得激活和创建
L=word_PageSetup(Document);%% 页面设置
Content.Start = 0;%设定光标位置
Paragraphformat = Selection.ParagraphFormat;

Num.figures=1;n_table=1;Num.equation=1;Num.Table=1;Num.refer=1;%用于记录图片、表格、公式、参考文献得个数
%% %%%%%%%%%%%%%%%%%%%%%%%%标题%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
title = strcat(filename,'应力应变数据处理报告');
Content.Text = title;L=set_format_title1(Content);%字体和段落格式设定 
%% 
n_title2=1;n_title3=1;n_title4=1;%用于记录二级，三级，四级标题
Selection.Start = Content.end;Selection.TypeParagraph;% 定义开始的位置为上一段结束的位置%换行插入内容并定义字体字号
Title1 = strcat(num2str(n_title2),'. 原始数据');n_title2=n_title2+1;
Selection.Text = Title1;L=set_format_title2(Selection);%格式设定

Selection.Start = Content.end;Selection.TypeParagraph;% 定义开始的位置为上一段结束的位置%换行插入内容并定义字体字号
[T1_content] =Title1_content();

for i=1:size(T1_content)%不同段落的写入
Selection.Text = T1_content{i,1};L=set_format_for_text(Selection);
Selection.Start = Content.end;Selection.TypeParagraph;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%应力应变获取和计算%%%%%%%%%%%%%%%%%%%%%%%%%%% %
joint_point.ratio=[0.93,1];%拼接点处应力比
[maximum,joint_point,stress,full_strain_gauge_t,full_strain_gauge_v1,full_strain_gauge_v2,strain_lvdt1,strain_lvdt2,...
ultimate_stress,index_for_stress,strain_gauge0,strain_gauge1,strain_gauge2,strain_gauge_average,...
ultimate_strain_gauge0,ultimate_strain_gauge1,ultimate_strain_gauge2,ultimate_strain_lvdt1,ultimate_strain_lvdt2]...
=reading_orignal_data_from_excell(fileadress,N,joint_point); %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%应变数据拼接和平均%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
[strain_joint11,strain_joint22,strain_joint12,strain_joint21,... %
strain_joint11_22,strain_joint12_21,strain_joint12_22,strain_joint11_21,index_for_joint,index_for_joint_average]...
=first_proces_orignal_data(index_for_stress,strain_gauge1,strain_lvdt1,strain_gauge2,strain_lvdt2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [I1,I_strain,I_strain_jiont,I_strain_jiont_average]=original_and_first_proces_data_save(full_strain_gauge_t,full_strain_gauge_v1,full_strain_gauge_v2,stress,strain_lvdt1,strain_lvdt2,...
%                                                      ultimate_stress,strain_gauge0,strain_gauge1,strain_gauge2,...
%                                                      ultimate_strain_gauge0,ultimate_strain_gauge1,ultimate_strain_gauge2,ultimate_strain_lvdt1,ultimate_strain_lvdt2,...
%                                                      strain_joint11,strain_joint22,strain_joint12,strain_joint21,...
%                                                      strain_joint11_22,strain_joint12_21,strain_joint12_22,strain_joint11_21,...
%                                                      index_for_stress,index_for_joint,index_for_joint_average,...                                                   
%                                                      fileadress,filename);

I=1;%图的编号
[I,II,Document,Content,Selection,Num,n_table]=original_and_first_proces_data_figures(maximum,stress,full_strain_gauge_t,full_strain_gauge_v1,full_strain_gauge_v2,strain_lvdt1,strain_lvdt2,...
                                             joint_point,index_for_stress,index_for_joint,index_for_joint_average,strain_gauge1,strain_gauge2,strain_gauge_average,...
                                             strain_joint11,strain_joint22,strain_joint12,strain_joint21,...
                                             strain_joint11_22,strain_joint12_21,strain_joint12_22,strain_joint11_21,...
                                             fileadress,filename,I,...
                                             Document,Content,Selection,Num,n_table);

% 参数计算及数据拟合
% -------------------------------------------------------------------------
[I,Ei,E13,Ep,beta_c1,beta_c2,           A_joint,beta_joint,b_joint,R2_joint,...
 Document,Content,Selection,Num,n_table,A_average,beta_average,b_average,R2_average,n_title2,n_title3]=fit_data_figures_with_beta_b(fileadress,filename,I,Document,Content,Selection,Num,n_table,n_title2);

[A_joint_beta,beta_joint_beta,R2_joint_beta,Document,Content,Selection,Num,n_table,A_average_beta,beta_average_beta,R2_average_beta,n_title2,n_title3]=fit_data_figures_with_beta(fileadress,filename,I,Document,Content,Selection,Num,n_table,n_title2,n_title3);


[C_A,C_beta,C_b,C_R2,Document,Content,Selection,Num,n_table,n_title2,n_title3]=fit_data_figures_with_b(fileadress,filename,I,Document,Content,Selection,Num,n_table,n_title2,n_title3,beta_c1,beta_c2);

%规范里的
[A_joint_code,beta_joint_code,alpha_joint,R2_joint_beta_code,R2_joint_alph,Document,Content,Selection,Num,n_table,A_average_code,average_beta_code,average_alph,R2_average_beta_code,R2_average_alph,n_title2,n_title3]=fit_data_figures_with_alpha_beta(fileadress,filename,I,Document,Content,Selection,Num,n_table,n_title2,n_title3);


[I0]=fitted_and_original_data_save(A_joint,beta_joint,b_joint,R2_joint,A_average,beta_average,b_average,R2_average,A_joint_beta,beta_joint_beta,R2_joint_beta,A_average_beta,beta_average_beta,R2_average_beta,C_A,C_beta,C_b,C_R2,A_joint_code,beta_joint_code,alpha_joint,R2_joint_beta_code,R2_joint_alph,A_average_code,average_beta_code,average_alph,R2_average_beta_code,R2_average_alph,fileadress,filename);


Document.Save; % 保存文档
% 
% % Document.Close; % 关闭文档
% %  Word.Quit; % 退出word服务器
% 
%  Excel = accelltxserver('Excel.Application');% 否则，创建一个Microsoft Word服务器，返回句柄Word
%  Excel.Visible = 1; % 或set(Word, 'Visible', 1);
%  Excel.Quit; 
% 
% try% 判断Word是否已经打开，若已打开，就在打开的Word中进行操作，否则就打开Word
%     Excel = actxGetRunningServer('Excel.Application');% 若Word服务器已经打开，返回其句柄Word
% catch
%     Excel = actxserver('Excel.Application');% 否则，创建一个Microsoft Word服务器，返回句柄Word
% end
%  Excel = actxGetRunningServer('Excel.Application');% 若Word服务器已经打开，返回其句柄Word
% Excel.Visible = 1; % 或set(Word, 'Visible', 1);
% Excel.Quit; 
toc;

