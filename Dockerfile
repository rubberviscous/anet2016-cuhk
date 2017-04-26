FROM alantrrs/caffe-tsn

# install Dense_Flow dependencies
RUN apt-get update && apt-get -qq install -y libzip-dev
WORKDIR /opt
RUN git clone --recursive https://github.com/yjxiong/dense_flow.git && cd dense_flow && git checkout opencv-3.1 && mkdir build; cd build; cmake .. && make -j

WORKDIR /models
# Get models
# ucf101 rgb models, 3 splits
# RUN wget -O ucf101_split_1_tsn_rgb_reference_bn_inception.caffemodel http://mmlab.siat.ac.cn/tsn_model/ucf101_split_1_tsn_rgb_reference_bn_inception.caffemodel.v5
# RUN wget -O ucf101_split_2_tsn_rgb_reference_bn_inception.caffemodel http://mmlab.siat.ac.cn/tsn_model/ucf101_split_2_tsn_rgb_reference_bn_inception.caffemodel.v5
# RUN wget -O ucf101_split_3_tsn_rgb_reference_bn_inception.caffemodel http://mmlab.siat.ac.cn/tsn_model/ucf101_split_3_tsn_rgb_reference_bn_inception.caffemodel.v5

# # ucf101 flow models, 3 splits
# RUN wget -O ucf101_split_1_tsn_flow_reference_bn_inception.caffemodel http://mmlab.siat.ac.cn/tsn_model/ucf101_split_1_tsn_flow_reference_bn_inception.caffemodel.v5
# RUN wget -O ucf101_split_2_tsn_flow_reference_bn_inception.caffemodel http://mmlab.siat.ac.cn/tsn_model/ucf101_split_2_tsn_flow_reference_bn_inception.caffemodel.v5
# RUN wget -O ucf101_split_3_tsn_flow_reference_bn_inception.caffemodel http://mmlab.siat.ac.cn/tsn_model/ucf101_split_3_tsn_flow_reference_bn_inception.caffemodel.v5

# # hmdb51 rgb models, 3 splits
# RUN wget -O hmdb51_split_1_tsn_rgb_reference_bn_inception.caffemodel http://mmlab.siat.ac.cn/tsn_model/hmdb51_split_1_tsn_rgb_reference_bn_inception.caffemodel.v5
# RUN wget -O hmdb51_split_2_tsn_rgb_reference_bn_inception.caffemodel http://mmlab.siat.ac.cn/tsn_model/hmdb51_split_2_tsn_rgb_reference_bn_inception.caffemodel.v5
# RUN wget -O hmdb51_split_3_tsn_rgb_reference_bn_inception.caffemodel http://mmlab.siat.ac.cn/tsn_model/hmdb51_split_3_tsn_rgb_reference_bn_inception.caffemodel.v5

# # hmdb51 flow models, 3 splits
# RUN wget -O hmdb51_split_1_tsn_flow_reference_bn_inception.caffemodel http://mmlab.siat.ac.cn/tsn_model/hmdb51_split_1_tsn_flow_reference_bn_inception.caffemodel.v5
# RUN wget -O hmdb51_split_2_tsn_flow_reference_bn_inception.caffemodel http://mmlab.siat.ac.cn/tsn_model/hmdb51_split_2_tsn_flow_reference_bn_inception.caffemodel.v5
# RUN wget -O hmdb51_split_3_tsn_flow_reference_bn_inception.caffemodel http://mmlab.siat.ac.cn/tsn_model/hmdb51_split_3_tsn_flow_reference_bn_inception.caffemodel.v5
RUN wget -O bn_inception_anet_2016_temporal.caffemodel.v5 http://yjxiong.me/others/models/bn_inception_anet_2016_temporal.caffemodel.v5

RUN wget -O bn_inception_anet_2016_temporal_deploy.prototxt http://yjxiong.me/others/models/bn_inception_anet_2016_temporal_deploy.prototxt
RUN wget -O resnet200_anet_2016.caffemodel http://yjxiong.me/others/models/resnet200_anet_2016.caffemodel
RUN wget -O resnet200_anet_2016_deploy.prototxt http://yjxiong.me/others/models/resnet200_anet_2016_deploy.prototxt

# ADD models/hmdb51 /models/hmdb51
# ADD models/ucf101 /models/ucf101
# ADD tools /tools
ADD . /app

# install python dependencies
RUN pip install numpy
RUN pip install scipy
RUN pip install scikit-learn