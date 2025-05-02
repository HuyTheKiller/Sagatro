return {
    descriptions = {
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
					"{C:inactive,s:0.9}(Đang sao chép {C:attention,s:0.9}#1#"..(SMODS.Mods["Sagatro"].debug and "{C:inactive,s:0.9}với ID giá trị {C:attention,s:0.9}#4#{C:inactive,s:0.9})" or "{C:inactive,s:0.9})"),
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
                name = "Kềnh Khuyển",
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
            j_sgt_alice = {
                name = "Alice",
                text = {
                    "{C:attention}Nhân{} giá trị của mọi joker",
                    "thuộc về {C:dark_edition}Alice ở Xứ Sở Diệu Kì{}",
                    "thêm {C:attention}X#1#{} lần",
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
        dictionary = {
            b_join = "NHẬP",
            k_in_a_hurry_ex = "Tranh thủ lên!",
            k_too_late_ex = "Trễ rồi!",
            k_shrunk_ex = "Thu Nhỏ!",
            k_enlarged_ex = "Phóng To!",
            k_grin_ex = "Cười!",
            k_gone_ex = "Biến Mất!",
            k_poof_ex = "Pụp!",
            k_yeet_ex = "VÈO!",
            SGT_disable_other_jokers = "Tiến Trình Sagatro",
            SGT_disable_other_jokers_desc = {"Tắt mọi joker khác và bật tiến trình","cốt truyện tuyến tính"},
        },
    },
}