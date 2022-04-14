$(document).ready(function() {
	
	$("#tipoProveedorID").focus();
	
	esTab = true;

	//Definicion de Constantes y Enums  
	var catTipoTransaccionProveedores = {  
			'agrega':'1',
			'modifica':'2'};

	//------------ Msetodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('modifica', 'submit');
	$('#tipoPersona').attr("checked","0") ;


	$(':text').focus(function() {	
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});


	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','tipoProveedorID','funcionExito','funcionError');
		}
	});	



	$('#tipoProveedorID').bind('keyup',function(e) {	
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "tipoProveedorID";
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#tipoProveedorID').val();
			listaAlfanumerica('tipoProveedorID', '1', '1', camposLista, parametrosLista, 'listaTipoProveedores.htm');
		}
	});

	$('#tipoProveedorID').blur(function() {
		if($('#tipoProveedorID').val()!="" && esTab == true){
			validaTipoProveedor('tipoProveedorID');
		}		   
	});

	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionProveedores.agrega);
	});

	$('#modifica').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionProveedores.modifica);
	});	


	
	
	//------------ Validaciones de la Forma -------------------------------------

	$('#formaGenerica').validate({

		rules: {
			tipoProveedorID:{
				required: true	
			},
			descripcion: {
				required: true,
				maxlength : 200
			},
			tipoPersona: {
				required: true
			}
		},		
		messages: {		
			tipoProveedorID: {
				required: 'Específique el Tipo de Proveedor',

			},
			descripcion: {
				required: 'Específique la descripción del Proveedor',
				maxlength : 'Máximo 200 caracteres'
			},
			tipoPersona: {
				required: 'Específique el Tipo de Persona'
			}
		}		
	});



	//------------ Validaciones de Controles -------------------------------------


	function validaTipoProveedor(control) {
		var numTipoProveedor = $('#tipoProveedorID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		esTab = true;
		if(numTipoProveedor != '' && !isNaN(numTipoProveedor) && esTab){
			if(numTipoProveedor=='0'){
				habilitaBoton('agrega', 'submit');		
				deshabilitaBoton('modifica', 'submit');
				inicializaForma('formaGenerica','tipoProveedorID' );
				$('#descripcion').val('') ;
				$('#tipoPersona').attr("checked","0") ;
			} else {
				deshabilitaBoton('agrega', 'submit'); 
				habilitaBoton('modifica', 'submit');
				var conPrincipal = 1;
				var TipoProveedorBeanCon = {
						'tipoProveedorID': numTipoProveedor
				};
				//////////consulta de tipo proveedores/////////////////////////////			 
				tipoProvServicio.consultaPrincipal(conPrincipal,TipoProveedorBeanCon,function(tipoProveedor) {
					if(tipoProveedor!=null){
						//dwr.util.setValues(tipoProveedor);
						$('#descripcion').val(tipoProveedor.descripcion);
						if(tipoProveedor.tipoPersona=='F'){                                 
							$('#tipoPersona').attr("checked","1") ;
        				}
						else{
							if(tipoProveedor.tipoPersona=='M'){
								$('#tipoPersona2').attr("checked","1") ;
							}
						}
						esTab=true;
					}else{
						mensajeSis("No Existe el Tipo de Proveedor");
						deshabilitaBoton('modifica', 'submit');
						deshabilitaBoton('agrega', 'submit');
						inicializaForma('formaGenerica','tipoProveedorID' );
						$('#descripcion').val('');
						$('#tipoPersona').attr("checked","1") ;
						$('#tipoProveedorID').focus();
						$('#tipoProveedorID').select();	
						$('#tipoProveedorID').val('');

					}
				});
				
			}

		}
	}
	
});



function funcionExito(){
	$('#descripcion').val('');
	$('#tipoPersona').attr("checked","1") ;
	$('#tipoProveedorID').focus();
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('agrega', 'submit');

}

function funcionError(){
	$('#descripcion').val('');
	$('#tipoPersona').attr("checked","1") ;
	$('#tipoProveedorID').focus();
	$('#tipoProveedorID').val('');
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('agrega', 'submit');
}
