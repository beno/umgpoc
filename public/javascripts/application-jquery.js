jQuery.noConflict();

jQuery(document).ready(function($){
	var tableOptions = {
		"bJQueryUI": true,
		"sPaginationType": "full_numbers",
		"bAutoWidth": false
	}
	$('#contracts_table').dataTable(tableOptions);
	$('#invoices_table').dataTable(tableOptions);
	$('#claims_table').dataTable(tableOptions);
	$('#profile').tabs();
});

