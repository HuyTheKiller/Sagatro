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
        Sleeve = {
            sleeve_sgt_saga = {
                name = "Bọc Cổ Tích",
                text = {
                    "{C:attention}+#1#{} ộ Joker",
                    "{C:attention}+#2#{} Ante để thắng",
                    "{s:0.8,C:inactive}Một câu chuyện không có hồi kết.",
                    "{s:0.8,C:inactive}Hãy tạo lối đi vượt xa giới hạn.",
                },
            },
            sleeve_sgt_saga_alt = {
                name = "Bọc Cổ Tích",
                text = {
                    "{C:attention}+#1#{} ô shop",
                    "{C:attention}+#1#{} ô gói bài",
                    "{s:0.8,C:inactive}Tự mình nắm giữ tương lai.",
                    "{s:0.8,C:inactive}Đừng quên bản thân là ai.",
                },
            },
        },
        Blind = {
            bl_sgt_red_queen = {
                name = "Red Queen",
                text = {
                    "Mọi lá bị vô hiệu hoá cho đến khi",
                    "dùng Hãy Ăn Tôi!; Blind siêu lớn",
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
					"{C:inactive,s:0.9}(Đang sao chép {C:attention,s:0.9}#1#"..(Sagatro.debug and "{C:inactive,s:0.9} với ID giá trị {C:attention,s:0.9}#4#{C:inactive,s:0.9})" or "{C:inactive,s:0.9})"),
                },
            },
            j_sgt_mouse = {
                name = "Chuột",
                text = {
                    "{C:mult}+#1#{} Nhân",
                    "Áp dụng {C:attention}#2#{}",
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
                    "ghi điểm {C:attention}chỉ{} chứa {C:attention}2{} hoặc {C:attention}Át{}",
                },
            },
            j_sgt_caterpillar = {
                name = "Sâu Không Hư",
                text = {
                    "{C:attention}Ngẫu nhiên hoá{} {C:attention}bậc{} và {C:attention}chất{}",
                    "của {C:attention}#1#{} lá ghi điểm tiếp theo",
                    "{C:red,E:2}Tự huỷ{} và tạo ra",
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
                    "Thêm {C:money}$#3#{} {C:attention}giá bán{} lên mọi {C:attention}#1#{} ở cuối ván",
                    "Mất {C:money}$#4#{} {C:attention}giá bán{} nếu {C:attention}#1#{} bị bán đi",
                    "{C:attention}Vô hiệu{} mọi {C:attention}#1#{} khi bán",
                },
            },
            j_sgt_frog_footman = {
                name = "Ếch Hầu",
                text = {
                    "{C:attention}+#1#{} ô tiêu thụ",
                    "Khi mở #2# {C:attention}Gói Bài{} tiếp theo,",
                    "{C:attention}lấp đầy{} ô tiêu thụ bằng",
                    "lá tiêu thụ {C:attention}ngẫu nhiên{}",
                    "{C:red,s:0.8,E:2}Tự huỷ{s:0.8} khi hết lượt",
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
                    "{C:red,E:2}Tự huỷ{} nếu không",
                    "sở hữu {C:attention}#2#{}",
                },
            },
            j_sgt_pepper_caster = {
                name = "Lọ Hạt Tiêu",
                text = {
                    "{C:attention}Tái kích{} mọi joker",
                    "thêm {C:attention}#1#{} lần",
                    "{C:red,s:0.8,E:2}Tự huỷ{s:0.8} sau {C:attention,s:0.8}#2#{s:0.8} ván",
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
                name = "Nhà Vua",
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
                    "Xác suất {C:green}#1# trên #4#{} để {C:red,E:2}tự huỷ{}",
                    "sau mỗi tay bài, giảm đi {C:attention}1{} sau",
                    "mỗi lần kích hoạt {X:dark_edition,C:white}^Nhân{}",
                },
            },
            j_sgt_alice = {
                name = "Alice",
                text = {
                    "{C:attention}Nhân{} giá trị của mọi joker",
                    "thuộc về {C:sgt_sagadition}Alice ở Xứ Sở{}",
                    "{C:sgt_sagadition}Diệu Kì{} thêm {C:attention}X#1#{} lần",
                    "{s:0.8,C:inactive}Không tác dụng lên Alice khác",
                },
            },
            j_sgt_shepherd_boy = {
                name = "Cậu Bé Chăn Cừu",
                text = {
                    "Joker này thêm {C:mult}+#2#{} Nhân",
                    "mỗi tay bài đã chơi",
                    "Xác suất {C:green}#3# trên #4#{} để phá huỷ một",
                    "joker ngẫu nhiên và {C:attention}đặt lại{} nhân",
                    "{C:inactive}(Hiện tại là {C:mult}+#1#{C:inactive} Nhân)",
                },
            },
            j_sgt_puss_in_boots = {
                name = "Mèo Đi Hia",
                text = {
                    "Mỗi lá {C:attention}Già{} và {C:attention}Đầm{} đã chơi",
                    "cho {C:money}$#1#{} khi ghi điểm",
                    "{X:mult,C:white}X#2#{} Nhân nếu tay bài",
                    "ghi điểm chứa {C:attention}Bồi{}",
                },
            },
        },
        ["Saga Tooltip"] = {
            fusion_hint = {
                text = {
                    "Lá bài này có cơ chế kết hợp.",
                    "Hãy tìm lá đồng hành và kiếm",
                    "đủ tiền để sử dụng cơ chế này.",
                },
            },
            white_rabbit = {
                text = {
                    "{s:0.8}Chạy theo chú thỏ trắng vội vã, nhảy vào",
                    "{s:0.8}chiếc hố thỏ không đáy. Phía trước là ngõ cụt",
                    "{s:0.8}với một cánh cửa khóa, chiếc {s:0.8,C:sgt_sagadition}chìa khóa",
                    "{s:0.8}trên bàn nhưng quá cao để với tới.",
                },
            },
            kid_gloves_and_fan = {
                text = {
                    "{s:0.8}Chỗ này nóng thật, quạt một lúc mà tôi đút vừa được",
                    "{s:0.8}cái đôi găng tay nhỏ xíu đó, dòng nước mắt hồi nãy",
                    "{s:0.8}thành lũ khiến tôi bị cuốn trôi, cần {s:0.8,C:sgt_sagadition}ai đó{s:0.8} để giúp đỡ.",
                },
            },
            dodo_bird = {
                text = {
                    "{s:0.8}Những con vật đó thật vô lý. À, kia có phải là {s:0.8,C:sgt_sagadition}Thỏ Trắng",
                    "{s:0.8}không? Có vẻ như nó nhầm mình với Mary Ann, người hầu",
                    "{s:0.8}của nó, và ra lệnh mình về nhà lấy găng tay và quạt",
                    "{s:0.8}đã làm rơi trước đó. Chắc chúng ta cần đến {s:0.8,C:sgt_sagadition}\"Nhà\"{s:0.8} của nó.",
                },
            },
            unlabeled_bottle = {
                text = {
                    "{s:0.8}Trong thế giới này, uống thứ gì đó thì bị nhỏ lại, ăn thứ gì đó thì",
                    "{s:0.8}phóng to. Nếu {s:0.8,C:sgt_sagadition}uống nước này{s:0.8} khiến mình to lên, chắc ăn thứ gì đó",
                    "{s:0.8}sẽ làm mình nhỏ lại. Phải nhanh chóng nhỏ lại vì thật khó chịu.",
                    "{s:0.8}Hình như Thỏ Trắng đang gọi ai đó để kéo mình ra ngoài.",
                },
            },
            little_bill = {
                text = {
                    "{s:0.8}Đau quá, có vẻ như con thằn lằn định chôn mình",
                    "{s:0.8}bằng sỏi đá, nhưng khi đá sỏi rơi xuống sàn,",
                    "{s:0.8}nó lại biến thành {s:0.8,C:sgt_sagadition}những chiếc bánh{s:0.8}.",
                },
            },
            huge_dog = {
                text = {
                    "{s:0.8}Quào, một con cún khổng lồ! À không, thực ra là vì mình chỉ cao",
                    "{s:0.8}có gần 8 cm. Nó có vẻ vui khi thấy mình, nên mình quyết định",
                    "{s:0.8}tránh xa trước khi có mệnh hệ gì. Cho đến khi con cún {s:0.8,C:sgt_sagadition}\"KHUẤT\"",
                    "{s:0.8}bóng, có vẻ như ai đó đang ngân nga trước mặt mình thì phải.",
                },
            },
            caterpillar = {
                text = {
                    "{s:0.8}\"C-cô... là ai?\" Thật thô lỗ khi cứ hỏi mà không tự giới thiệu. Mặc dù",
                    "{s:0.8}tôi thấy áy náy khi bảo mình chỉ cao 8 cm trước mặt ông ta, nhưng",
                    "{s:0.8}ông ấy gọi tôi lại để nói gì đó. Thôi thì cứ nghe ổng nói {s:0.8,C:sgt_sagadition}HẾT{s:0.8} vậy.",
                },
            },
            mushroom = {
                text = {
                    "{s:0.8}Thứ này thật hữu ích, chắc mình sẽ cần phải {s:0.8,C:sgt_sagadition}để dành{s:0.8,C:sgt_sagadition} về sau.",
                    "{s:0.8}AAAH, {s:0.8,C:sgt_sagadition}nỡ cắn{s:0.8} miếng lớn quá, giờ đầu mình dài như con rắn vậy.",
                    "{s:0.8}Ủa, trên đầu mình có gì đó thì phải.",
                },
            },
            frog_footman = {
                text = {
                    "{s:0.8}\"Thật ngán ngẩm kinh khủng. Cái kiểu lập luận của các con vật đủ",
                    "{s:0.8}khiến người ta phát điên!\" Bực tức mà nói, nhưng bên trong {s:0.8,C:sgt_sagadition}nhà",
                    "{s:0.8}có vẻ ồn ào lộn xộn, hắn ta có vẻ không muốn vào vì lý do đó.",
                    "{s:0.8}Ờm, tôi cứ lờ hắn đi mà tự đi vào vậy.",
                },
            },
            cheshire_cat = {
                text = {
                    "{s:0.8}\"Ở đây tất cả chúng ta đều điên mà. Tôi điên. Cô cũng điên.\"",
                    "{s:0.8}Tôi đâu có điên đâu, mà thôi ngay cái kiểu {s:0.8,C:sgt_sagadition}thoắt ẩn",
                    "{s:0.8}thoắt hiện đấy đi, nhìn chóng cả mặt.",
                },
            },
            mad_hatter = {
                text = {
                    "{s:0.8}Cái bàn tiệc dài bao nhiêu là chỗ mà chỉ có {s:0.8,C:sgt_sagadition}ba{s:0.8} người ngồi nguyên một góc mà",
                    "{s:0.8}cũng kêu là hết chỗ, với lại cái cách nói chuyện thật khó chịu, mình phải tránh xa",
                    "{s:0.8}chỗ này mới được. Phía trước là một sảnh dài và có 1 cánh cửa cao khoảng 30 cm.",
                    "{s:0.8}Nhấm nháp một chút {s:0.8,C:sgt_sagadition}Nấm{s:0.8} còn giữ trong túi. Tôi men theo con đường sau cánh cửa...",
                },
            },
            red_queen = {
                text = {
                    "{s:0.8}\"Chặt đầu hắn cho ta!\" - Một nữ hoàng bạo chúa, có vẻ nếu mình không ngoan ngoãn nghe lời",
                    "{s:0.8}là sẽ rụng đầu mất. Bà ta chơi croquet với con {s:0.8,C:sgt_sagadition}Hồng Hạc{s:0.8} thay vì dùng mallet, nhưng có vẻ",
                    "{s:0.8}chúng hợp tác khiến bà vui. {s:0.8,C:sgt_sagadition}Nhà Vua{s:0.8} luôn bên cạnh, tâng bốc và xoa dịu cơn giận của bà,",
                    "{s:0.8}ngăn cản lệnh giết người vô lý. Hiện tại mình có vẻ làm sai gì đó khiến bà ta tức giận nhưng",
                    "{s:0.8}nếu chơi cùng bà và được nhà vua nói đỡ thì sao nhỉ? Này! {s:0.8,C:sgt_sagadition}Mèo Cheshire{s:0.8}, đừng quấy rối bà ta!!",
                },
            },
            gryphon = {
                text = {
                    "{s:0.8}\"Bà bạo chúa đó chỉ là đang ảo tưởng thôi, chứ có giết được",
                    "{s:0.8}ai đâu. Hẳn là bà ta đã ân xá cho cô và mong muốn cô gặp tôi",
                    "{s:0.8}để nghe bài ca của Súp {s:0.8,C:sgt_sagadition}Giả Rùa{s:0.8}. Lên lưng tôi đi, tôi chở cô",
                    "{s:0.8}đến hắn.\" Thứ mình sư tử đầu chim đó nói với tui như thế.",
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
                    "{C:attention}Hình Ảnh Gốc{}: HuyCorn, Amy, TNhie, Kazumi",
                    "{C:attention}Chỉnh Sửa Ảnh{}: HuyTheKiller",
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
            saga_tooltip = "Gợi ý tiến triển",
            saga_fusion_tooltip = "Kết hợp joker",
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
            k_guilty_ex = "Có Tội!",
            k_to = "để",
            k_self_destruct = "tự huỷ",
            k_self_destruct_ex = "Tự Huỷ!",
            k_amused_ex = "Hế Hế!",
            k_wolf_ex = "Sói!",
            k_amnestied_ex = "Ân Xá!",
            ph_per_face_down = " mỗi lá sấp",
            ph_trial_begins = "Khai Toà!",
            ph_story_ended = "KẾT TRUYỆN!",
            ph_alice_in_wond = "Alice ở Xứ Sở Diệu Kì",
            ph_misc_story = "Truyện Khác",
            SGT_disable_other_jokers = "Chế Độ Cốt Truyện",
            SGT_disable_other_jokers_desc = {"Tắt mọi joker khác và bật tiến trình","cốt truyện tuyến tính (Yêu cầu tạo trận mới)"},
        },
    },
}