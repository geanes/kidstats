raw <- # put path to raw data here
salb_za_raw <- read.csv(raw, stringsAsFactors=FALSE)
salb_za_raw <- dplyr::select(salb_za_raw, id = cat_num, sex, ancestry, age_y,
                             h_mxl, h_pb, h_db, h_msb, u_mxl, u_msb, r_mxl,
                             r_pb, r_db, r_msb, f_mxl, f_db, f_msb, t_mxl, t_pb,
                             t_db, t_msb, fb_mxl)
salb_za_raw$sex <- factor(salb_za_raw$sex)
salb_za_raw$ancestry <- factor(salb_za_raw$ancestry)

# outlying measurements become NA ---------------------------------------------
fmxl_out <- c(731, 164, 514)
salb_za_raw[which(salb_za_raw$id %in% fmxl_out), which(names(salb_za_raw) == "f_mxl")] <- NA
fdb_out <- c(804, 948)
salb_za_raw[which(salb_za_raw$id %in% fdb_out), which(names(salb_za_raw) == "f_db")] <- NA
fmsb_out <- c(1352)
salb_za_raw[which(salb_za_raw$id %in% fmsb_out), which(names(salb_za_raw) == "f_msb")] <- NA
hmxl_out <- c(86, 514)
salb_za_raw[which(salb_za_raw$id %in% hmxl_out), which(names(salb_za_raw) == "h_mxl")] <- NA
hpb_out <- c(796)
salb_za_raw[which(salb_za_raw$id %in% hpb_out), which(names(salb_za_raw) == "h_pb")] <- NA
hdb_out <- c(1025, 229, 1000)
salb_za_raw[which(salb_za_raw$id %in% hdb_out), which(names(salb_za_raw) == "h_db")] <- NA
hmsb_out <- c(478, 386, 377)
salb_za_raw[which(salb_za_raw$id %in% hmsb_out), which(names(salb_za_raw) == "h_msb")] <- NA
fbmxl_out <- c(164)
salb_za_raw[which(salb_za_raw$id %in% fbmxl_out), which(names(salb_za_raw) == "fb_mxl")] <- NA
umxl_out <- c(1201, 348)
salb_za_raw[which(salb_za_raw$id %in% umxl_out), which(names(salb_za_raw) == "u_mxl")] <- NA
umsb_out <- c(77, 462, 495, 171, 876, 796, 118, 378, 873, 1352)
salb_za_raw[which(salb_za_raw$id %in% umsb_out), which(names(salb_za_raw) == "u_msb")] <- NA
rmxl_out <- c(1201)
salb_za_raw[which(salb_za_raw$id %in% rmxl_out), which(names(salb_za_raw) == "r_mxl")] <- NA
rdb_out <- c(602, 352, 462, 485, 682)
salb_za_raw[which(salb_za_raw$id %in% rdb_out), which(names(salb_za_raw) == "r_db")] <- NA
rmsb_out <- c(953, 1352, 241, 876, 873, 796)
salb_za_raw[which(salb_za_raw$id %in% rmsb_out), which(names(salb_za_raw) == "r_msb")] <- NA
rpb_out <- c(1352)
salb_za_raw[which(salb_za_raw$id %in% rpb_out), which(names(salb_za_raw) == "r_pb")] <- NA
tmxl_out <- c(664, 164, 1030, 514, 752, 238, 842, 621, 241, 1333)
salb_za_raw[which(salb_za_raw$id %in% tmxl_out), which(names(salb_za_raw) == "t_mxl")] <- NA
tdb_out <- c(47, 638, 804, 948)
salb_za_raw[which(salb_za_raw$id %in% tdb_out), which(names(salb_za_raw) == "t_db")] <- NA
tpb_out <- c(462, 638, 1032, 664, 636, 540, 205, 1354, 541)
salb_za_raw[which(salb_za_raw$id %in% tpb_out), which(names(salb_za_raw) == "t_pb")] <- NA
tmsb_out <- c(638, 636, 1354, 573, 510, 19, 377)
salb_za_raw[which(salb_za_raw$id %in% tmsb_out), which(names(salb_za_raw) == "t_msb")] <- NA

salb_za <- salb_za_raw
