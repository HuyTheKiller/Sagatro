return {
    descriptions = {
        Back = {
            b_sgt_saga = {
                name = "Bộ Bài Cổ Tích",
                text = {
                    "{C:attention}+#1#{} ô Joker",
                    "Đánh bại {C:attention}Ante #2#{} để thắng",
                    "{s:0.8,C:inactive}Một câu chuyện không có hồi kết.",
                    "{s:0.8,C:inactive}Hãy tạo lối đi vượt xa giới hạn.",
                },
            },
        },
        Joker = {
            j_sgt_white_rabbit = {
                name = "Thỏ Trắng",
                text = {
                    "Joker này thêm {C:chips}+#2#{} Chip",
                    "nếu tay bài được chơi khi {C:attention}chưa{}",
                    "dùng lượt bỏ bài nào ở ván này",
                    "{C:inactive}(Hiện tại là {C:chips}+#1#{C:inactive} Chip)",
                },
            },
            j_sgt_drink_me = {
                name = "Hãy Uống Tôi!",
                text = {
                    "Nếu lá này ở {C:attention}tít bên trái{},",
                    "{C:attention}biến đổi{} mọi lá ghi điểm thành {C:attention}2{}",
                    "trong {C:attention}#1#{} tay bài tiếp theo",
                    "{s:0.8,C:inactive}Không kích hoạt nếu",
                    "{s:0.8,C:attention}#2#{s:0.8,C:inactive} ở tít bên phải",
                },
            },
            j_sgt_eat_me = {
                name = "Hãy Ăn Tôi!",
                text = {
                    "Nếu lá này ở {C:attention}tít bên phải{},",
                    "{C:attention}biến đổi{} mọi lá ghi điểm thành {C:attention}Át{}",
                    "trong {C:attention}#1#{} tay bài tiếp theo",
                    "{s:0.8,C:inactive}Không kích hoạt nếu",
                    "{s:0.8,C:attention}#2#{s:0.8,C:inactive} ở tít bên trái"
                },
            },
            j_sgt_cheshire_cat = {
                name = "Mèo Cheshire",
                text = {
                    "Sao chép khả năng của một {C:attention}Joker{}",
					"ngẫu nhiên khi {C:attention}Blind{} được chọn",
                    "Xác suất {C:green}#2# trên #3#{} lá này",
                    "bị phá huỷ ở cuối ván",
					"{C:inactive,s:0.9}(Đang sao chép {C:attention,s:0.9}#1#"..(SMODS.Mods["Sagatro"].debug and "{C:inactive,s:0.9} với ID giá trị {C:attention,s:0.9}#4#{C:inactive,s:0.9})" or "{C:inactive,s:0.9})"),
                },
            },
            j_sgt_mouse = {
                name = "Chuột",
                text = {
                    "{C:mult}+#1#{} Nhân",
                    "Giữ nguyên trạng thái {C:attention}vô hiệu{}",
                    "nếu joker này ở vị trí",
                    "{C:attention}đã đặt từ trước{} trong ván này",
                },
            },
            j_sgt_kid_gloves_and_fan = {
                name = "Găng Tay Và Chiếc Quạt",
                text = {
                    "Nếu lá này ở {C:attention}tít bên trái{}:",
                    "Lá đã chơi {C:attention}giảm đi{} #1# bậc khi ghi điểm",
                    "Lá 2 bị {C:attention}phá huỷ{} sau khi ghi điểm",
                },
            },
            j_sgt_dodo_bird = {
                name = "Chim Dodo",
                text = {
                    "Mỗi joker ghi thêm {X:mult,C:white}X#1#{} Nhân",
                    "ở {C:attention}tay bài cuối{} của ván",
                    "với {C:attention}0{} lượt bỏ bài",
                },
            },
            j_sgt_unlabeled_bottle = {
                name = "Chai Không Nhãn",
                text = {
                    "Nếu lá này ở {C:attention}tít bên trái{},",
                    "{C:attention}biến đổi{} mọi lá ghi điểm thành {C:attention}Át{}",
                    "trong {C:attention}#1#{} tay bài tiếp theo",
                },
            },
            j_sgt_unlabeled_bottle_collection = {
                name = "Chai Không Nhãn",
                text = {
                    "{C:inactive}Không có nhãn à?",
                    "{C:inactive}Tác dụng là gì nhỉ?",
                },
            },
            j_sgt_little_bill = {
                name = "Bill",
                text = {
                    "{C:attention}#1#{} giờ đây {C:attention}biến đổi{}",
                    "mọi lá ghi điểm thành {C:attention}2{}",
                },
            },
            j_sgt_huge_dog = {
                name = "Khổng Cún",
                text = {
                    "{C:attention}Tái kích{} lá {C:attention}2{}",
                    "hoặc {C:attention}Át{} thêm {C:attention}#1#{} lần",
                    "Tái kích {C:attention}#2#{} lần nữa nếu tay bài",
                    "đã chơi {C:attention}chỉ{} chứa {C:attention}2{} hoặc {C:attention}Át{}",
                },
            },
            j_sgt_caterpillar = {
                name = "Sâu Bướm",
                text = {
                    "{C:attention}Ngẫu nhiên hoá{} {C:attention}bậc{} và {C:attention}chất{}",
                    "của {C:attention}#1#{} lá ghi điểm tiếp theo",
                    "{C:red}Tự huỷ{} và tạo ra",
                    "{C:attention}#2#{} khi hết lượt",
                },
            },
            j_sgt_mushroom = {
                name = "Nấm",
                text = {
                    "Nếu lá này ở {C:attention}tít bên trái/phải{},",
                    "Mọi lá ghi điểm {C:attention}giảm/tăng{} #2# bậc",
                    "trong {C:attention}#1#{} tay bài tiếp theo",
                },
            },
            j_sgt_pigeon = {
                name = "Bồ Câu",
                text = {
                    "Mua lá này để tạo ra #2# {C:attention}#1#{}",
                    "Thêm {C:money}$#3#{} {C:attention}giá bán{} lên",
                    "mọi {C:attention}#1#{} ở cuối ván",
                    "{C:attention}Vô hiệu{} nếu {C:attention}#1#{} bị bán đi",
                },
            },
            j_sgt_frog_footman = {
                name = "Ếch Hầu",
                text = {
                    "{C:attention}+#1#{} ô tiêu thụ",
                    "Khi mở #2# {C:attention}Gói Bài{} tiếp theo,",
                    "{C:attention}lấp đầy{} ô tiêu thụ bằng",
                    "lá tiêu thụ {C:attention}ngẫu nhiên{}",
                    "{C:red,s:0.8}Tự huỷ{s:0.8} khi hết lượt",
                },
            },
            j_sgt_the_cook = {
                name = "Nữ Đầu Bếp",
                text = {
                    "Xác suất {C:green}#1# trên #2#{}",
                    "để lá bài bị {C:attention}bốc{} sấp",
                    "Lá {C:attention}nằm sấp{} ghi thêm",
                    "{X:mult,C:white}X#3#{} Nhân khi ghi điểm",
                    "{s:0.8}Chuyển sang 1 cặp giá",
                    "{s:0.8}trị khác ở cuối ván",
                },
            },
            j_sgt_duchess = {
                name = "Nữ Công Tước",
                text = {
                    "Xác suất {C:green}#1# trên #2#{} để phá huỷ",
                    "từng lá {C:attention}mặt{} ghi điểm",
                    "{X:dark_edition,C:white}^#3#{} Nhân nếu bất kì lá {C:attention}mặt{}",
                    "nào bị phá huỷ bằng cách này",
                },
            },
            j_sgt_the_baby = {
                name = "Đứa Bé",
                text = {
                    "{C:attention}Tái kích{} mọi lá",
                    "đã chơi thêm {C:attention}#1#{} lần",
                    "ở {C:attention}tay bài cuối{} của ván",
                    "{C:red}Tự huỷ{} nếu không",
                    "sở hữu {C:attention}#2#{}",
                },
            },
            j_sgt_pepper_caster = {
                name = "Lọ Hạt Tiêu",
                text = {
                    "{C:attention}Tái kích{} mọi joker",
                    "thêm {C:attention}#1#{} lần",
                    "{C:red,s:0.8}Tự huỷ{s:0.8} sau {C:attention,s:0.8}#2#{s:0.8} ván",
                },
            },
            j_sgt_mad_hatter = {
                name = "Thợ Làm Mũ",
                text = {
                    "Vô hiệu {C:attention}Thăng Ante{}",
                    "Lấp đầy shop bằng",
                    "joker {C:sgt_trivial}Tầm Thường{}",
                },
            },
            j_sgt_tea = {
                name = "Trà",
                text = {
                    "{C:chips}+#1#{} Chip trong",
                    "{C:attention}#2#{} tay bài tiếp theo",
                },
            },
            j_sgt_bread = {
                name = "Bánh Mì",
                text = {
                    "{C:chips}+#1#{} Chip trong",
                    "{C:attention}#2#{} tay bài tiếp theo",
                },
            },
            j_sgt_butter = {
                name = "Bơ",
                text = {
                    "{C:mult}+#1#{} Nhân trong",
                    "{C:attention}#2#{} tay bài tiếp theo",
                },
            },
            j_sgt_march_hare = {
                name = "Thỏ Rừng",
                text = {
                    "Joker này thêm {C:mult}+#2#{} Nhân",
                    "nếu tay bài được chơi khi {C:attention}chưa{}",
                    "dùng lượt bỏ bài nào ở ván này",
                    "{C:inactive}(Hiện tại là {C:mult}+#1#{C:inactive} Nhân)",
                },
            },
            j_sgt_dormouse = {
                name = "Chuột Sóc",
                text = {
                    "Xác suất {C:green}#1# trên #2#",
                    "để được {C:mult}+#3#{} Nhân",
                },
            },
            j_sgt_red_queen = {
                name = "Nữ Hoàng Đỏ",
                text = {
                    "Xác suất {C:green}#1# trên #2#{} để",
                    "phả huỷ lá ghi điểm",
                    "Mọi lá đã chơi ghi thêm",
                    "{X:dark_edition,C:white}^#3#{} Nhân khi ghi điểm",
                },
            },
            j_sgt_king = {
                name = "Ông Vua",
                text = {
                    "{C:mult}+#1#{} Nhân",
                    "Giảm xác suất của",
                    "{C:attention}#2#{} đi {C:attention}#3#{} lần",
                },
            },
            j_sgt_flamingo = {
                name = "Hồng Hạc",
                text = {
                    "{C:chips}+#1#{} Chip",
                    "Giảm xác suất của",
                    "{C:attention}#2#{} đi {C:attention}#3#{} lần",
                },
            },
            j_sgt_gryphon = {
                name = "Gryphon",
                text = {
                    "Mỗi lá {C:attention}Đầm{}",
                    "giữ trong tay",
                    "ghi thêm {X:dark_edition,C:white}^#1#{} Nhân",
                },
            },
            j_sgt_mock_turtle = {
                name = "Giả Rùa",
                text = {
                    "Xác suất {C:green}#1# trên #2#{} để được {X:dark_edition,C:white}^#3#{} Nhân",
                    "Xác suất {C:green}#1# trên #4#{} để {C:red}tự huỷ{}",
                    "sau mỗi tay bài, giảm đi {C:attention}1{} sau",
                    "mỗi lần kích hoạt {X:dark_edition,C:white}^Nhân{}",
                },
            },
            j_sgt_alice = {
                name = "Alice",
                text = {
                    "{C:attention}Nhân{} giá trị của mọi joker",
                    "thuộc về {C:dark_edition}Alice ở Xứ Sở{}",
                    "{C:dark_edition}Diệu Kì{} thêm {C:attention}X#1#{} lần",
                },
            },
        },
        Mod = {
            Sagatro = {
                name = "Sagatro",
                text = {
                    "{s:1.3}Thêm yếu tố {s:1.3,C:dark_edition}cổ tích {s:1.3}vào Balatro.",
                    " ",
                    "Danh đề:",
                    "{C:attention}Hình Ảnh{}: HuyCorn, Amy",
                    "{C:attention}Ý Tưởng{}: HuyCorn",
                    "{C:attention}Cân Bằng{}: HuyTheKiller, HuyCorn",
                    " ",
                    "Hiện đang ở bản demo.",
                },
            },
        },
    },
    misc = {
        labels = {
            k_sgt_trivial = "Tầm Thường",
            k_sgt_obscure = "Mờ Mịt",
            k_sgt_esoteric = "Bí Truyền",
        },
        dictionary = {
            k_sgt_trivial = "Tầm Thường",
            k_sgt_obscure = "Mờ Mịt",
            k_sgt_esoteric = "Bí Truyền",
            b_join = "NHẬP",
            k_in_a_hurry_ex = "Tranh thủ lên!",
            k_too_late_ex = "Trễ rồi!",
            k_shrunk_ex = "Thu Nhỏ!",
            k_enlarged_ex = "Phóng To!",
            k_grin_ex = "Cười!",
            k_gone_ex = "Biến Mất!",
            k_poof_ex = "Pụp!",
            k_yeet_ex = "VÈO!",
            k_ouch_ex = "Úi!",
            k_goodbye_ex = "Tạm Biệt!",
            k_go_off_ex = "Bỏ Đi!",
            k_overflow_ex = "Tràn!",
            k_die_ex = "Chết Đi!",
            k_stirred_ex = "Khuấy Đều!",
            k_shared_ex = "Chia Sẻ!",
            k_avoided_ex = "Lảng Tránh!",
            k_enraged_ex = "Điên Tiết!",
            SGT_disable_other_jokers = "Chế Độ Cốt Truyện",
            SGT_disable_other_jokers_desc = {"Tắt mọi joker khác và bật tiến trình","cốt truyện tuyến tính (Yêu cầu tạo trận mới)"},
        },
    },
}