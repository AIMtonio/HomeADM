$(document).ready(function() {
	esTab = true;
	var tab2=false;	
	
	var parametroBean = consultaParametrosSession();
	var fechaSistema = parametroBean.fechaSucursal;	
	$('#fecha').val(fechaSistema);
	
	
	//Definicion de Constantes y Enums  
	var tipoActualizacion= {
			'ninguna': '0',
			'bloquear': '1',
			'desbloquear': '2'					
		};
	
	var tipoTransaccion= {			
			'agregar': '1',
			'actualizar': '2'					
		};
				
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('buscar', 'submit');		
	$('#tipoBusqueda').focus();

	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});			

	$.validator.setDefaults({
		submitHandler : function(event) {				  						
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica',
					'contenedorForma', 'mensaje', 'true',
					'cuentasBcaMovID', 'funcionExito',
					'funcionError'); 	
		}	  		
		  	
	});
	
	$('#tipoBusqueda').change(function(){	
		$("#formaGenerica").validate().resetForm();	
		$("#formaGenerica").find(".error").removeClass("error");
		if($('#tipoBusqueda').val() == 1){					
			limpiaCampos();
			deshabilitaBoton('buscar', 'submit');	
			deshabilitaControl('clienteID');						
			$('#gridUsuariosPDM').html("");
			$('#gridUsuariosPDM').hide();
		}else if ($('#tipoBusqueda').val() == 2 || $('#tipoBusqueda').val() == 3){
			limpiaCampos();
			deshabilitaBoton('buscar', 'submit');
			habilitaControl('clienteID');
			$('#clienteID').val('');
			$('#clienteID').focus();					
			$('#gridUsuariosPDM').html("");
			$('#gridUsuariosPDM').hide();
							
		}else{
			mensajeSis('Seleccione un Tipo de Búsqueda');
		}

	});


	$('#buscar').click(function(){
		consultaRegistroUsua();	
	});			
	

	$('#clienteID').bind('keyup',function(e){ 
		if($('#tipoBusqueda').val() == 2){
			
			var camposLista = new Array(); 
		    var parametrosLista = new Array(); 
		    	camposLista[0] = "nombreCompleto";
		    	parametrosLista[0] = $('#clienteID').val();
		    	
			lista('clienteID', '2', '3', camposLista, parametrosLista,'listaUsuarioBCAMovil.htm');
			
		}else if($('#tipoBusqueda').val() == 3){
			if(isNaN($('#clienteID').val()) && $('#clienteID').val().indexOf("%") == -1){ 
				$('#clienteID').val('');
				$('#clienteID').focus();										
				
			}else{								
				var camposLista = new Array(); 
			    var parametrosLista = new Array(); 
			    	camposLista[0] = "nombreCompleto";
			    	parametrosLista[0] = $('#clienteID').val();
			    	
			    listaAlfanumerica('clienteID', '2', '4', camposLista, parametrosLista,'listaUsuarioBCAMovil.htm');						
			}								
		}				
		
	});
	

	$('#clienteID').blur(function() {
		if(isNaN($('#clienteID').val())){
			$('#clienteID').focus();
			
		}else{
			consultaClientePantalla();
		}	
		
	});	
	
	$('#fechaInicial').change(function () {		
		if($('#fechaInicial').val() > fechaSistema ){						
			mensajeSis('La Fecha no Puede ser Mayor a la del Sistema');
			$('#fechaInicial').val('');						
		}
		if($('#fechaInicial').val() > $('#fechaFinal').val() && $('#fechaFinal').val() != ''){
			mensajeSis('La Fecha de Inicio no Puede ser Mayor a la de Fin');
			$('#fechaInicial').val('');	
		}		
	});   
	$('#fechaFinal').change(function () {		
		if($('#fechaFinal').val() > fechaSistema ){						
			mensajeSis('La Fecha no Puede ser Mayor a la del Sistema');
			$('#fechaFinal').val('');						
		}
		if($('#fechaFinal').val() < $('#fechaInicial').val() && $('#fechaFinal').val() != ''){
			mensajeSis('La Fecha de Inicio no Puede ser Mayor a la de Fin');
			$('#fechaFinal').val('');	
		}	
	});  
	
	 
	//------------ Validaciones de la Forma -------------------------------------

	$('#formaGenerica').validate({

		rules : {
			clienteID : {
				required : true,
			},
			
		},
		messages : {					
			clienteID : {
				required : 'Especifique Número de Cliente'
			},					
		}
	});

	//------------ Validaciones de Controles -------------------------------------

});
function consultaClientePantalla(){	
	var numCliente = $('#clienteID').val();		
	var tipConPantalla = 2;
	
	var CuentasBeanCon = {
			'clienteID' : numCliente
		};

	setTimeout("$('#cajaLista').hide();", 200);
	if(numCliente != '' && !isNaN(numCliente) && esTab){ 
		$('#gridUsuariosPDM').html("");
		$('#gridUsuariosPDM').hide();
		cuentasBCAMovilServicio.consulta(tipConPantalla, CuentasBeanCon,{ async: false, callback:
			function(cliente){							
				if (cliente != null){										
					$('#clienteID').val(cliente.clienteID);
					$('#nombreCompleto').val(cliente.nombreCompleto);						
																
					habilitaBoton('buscar', 'submit');		
					$('#fechaInicial').focus();
	
				}else{
					mensajeSis("No Existe el Cliente");									
					$('#clienteID').focus();
					$('#clienteID').val('');	
					deshabilitaBoton('buscar', 'submit');
				}					
						
			}
	
		});				
	}
}

//funcion para consultar los usuarios registrados en pademobil
function consultaRegistroUsua(){
	var numCte =$('#clienteID').val();
	var fehaIni =$('#fechaInicial').val();
	var fechaFIn =$('#fechaFinal').val();
	var params = {
	'clienteID'	:numCte,
	'fechaInicial':fehaIni,
	'fechaFinal':fechaFIn
	};
	params['tipoLista'] = 5;
	$.post("gridCtaUsuaBCAMovil.htm", params, function(data) {
		if (data.length > 0) {
			agregaFormatoControles('formaGenerica');
			$('#gridUsuariosPDM').html(data);
			$('#gridUsuariosPDM').show();
			
			if($('#cuentaAhoIDG1').val() != undefined ){
				agregaMask();			
			}	

		} else {
			$('#gridUsuariosPDM').html("");
			$('#gridUsuariosPDM').hide();
			mensajeSis("No se tienen Registros");
			
		}
	});	
}

function agregaMask(){
	$('tr[name=renglon]').each(function() {
		var numero= this.id.substr(7,this.id.length);
		var jqIdTelefono = eval("'telefonoBD" + numero+ "'");		
				
		$('#'+jqIdTelefono).setMask('phone-us');			
	
	});
}

function limpiaCampos(){	
    $('#clienteID').val('');
	$('#nombreCompleto').val('');
	$('#fechaInicial').val('');
	$('#fechaFinal').val('');	
}

function funcionExito() {

}

function funcionError() {

}
