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
                    "{s:0.8,C:attention}Hãy Ăn Tôi!{s:0.8,C:inactive} ở tít bên phải",
                },
            },
            j_sgt_eat_me = {
                name = "Hãy Ăn Tôi!",
                text = {
                    "Nếu lá này ở {C:attention}tít bên phải{},",
                    "{C:attention}biến đổi{} mọi lá ghi điểm thành {C:attention}Át{}",
                    "trong {C:attention}#1#{} tay bài tiếp theo",
                    "{s:0.8,C:inactive}Không kích hoạt nếu",
                    "{s:0.8,C:attention}Hãy Uống Tôi!{s:0.8,C:inactive} ở tít bên trái"
                },
            },
            j_sgt_chesire_cat = {
                name = "Mèo Chesire",
                text = {
                    "Sao chép khả năng của một {C:attention}Joker{}",
					"ngẫu nhiên khi {C:attention}Blind{} được chọn",
                    "Xác suất {C:green}#2# trên #3#{} lá này",
                    "bị phá huỷ ở cuối ván",
					"{C:inactive,s:0.9}(Đang sao chép {C:attention,s:0.9}#1#"..(SMODS.Mods["Sagatro"].debug and "{C:inactive,s:0.9}với ID giá trị {C:attention,s:0.9}#4#{C:inactive,s:0.9})" or "{C:inactive,s:0.9})"),
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
                    " ",
                    "Hiện đang ở bản demo. Mod này sẽ loại bỏ",
                    "toàn bộ joker gốc ở bản đầy đủ.",
                },
            },
        },
    },
    misc = {
        dictionary = {
            k_in_a_hurry_ex = "Tranh thủ lên!",
            k_too_late_ex = "Trễ rồi!",
            k_shrunk_ex = "Thu Nhỏ!",
            k_enlarged_ex = "Phóng To!",
            k_grin_ex = "Cười!",
            k_gone_ex = "Biến Mất!",
        },
    },
}