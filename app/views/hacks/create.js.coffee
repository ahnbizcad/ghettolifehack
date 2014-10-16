$("#new-hack").slideUp(350)
$(".hacks").html("<%= j(render partial: "hacks/hack", collection: @hacks, as: :hack) %>")