$("#hack-<%= @hack.id %>").html("<%= j(render partial: 'hacks/form') %>")
$("#hack-<%= @hack.id %>").slideDown(350)
