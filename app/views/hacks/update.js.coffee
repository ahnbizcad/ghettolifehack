$("#hack-<%= @hack.id %>").slideUp(350)
$(".hacks").html("<%= j(render partial: "hacks/hack", collection: @hacks, as: :hack) %>")


