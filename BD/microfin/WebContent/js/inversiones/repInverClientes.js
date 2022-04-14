$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	$('#sucursalID').focus();
	var catTipoListaTipoInversion = {
			'principal':1
		};
	var catTipoConsultaTipoInversion = {
			'principal':1,
			'general':3
		};
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	var parametroBean = consultaParametrosSession();
	$('#clienteID').val(0);
	$('#nombreCte').val('TODOS');
	$('#pdf').attr("checked",true);
	$('#pantalla').attr("checked",false);
	$('#excel').attr("checked",false);
	$('#reporte').val(2);

	$(':text').focus(function() {	
	 	esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#pdf').click(function() {
		$('#pdf').focus();
		$('#pdf').attr("checked",true);
		$('#pantalla').attr("checked",false);
		$('#excel').attr("checked",false);
		$('#reporte').val(2);
	});
	
	$('#pantalla').click(function() {
		$('#pantalla').focus();
		$('#pantalla').attr("checked",true);
		$('#pdf').attr("checked",false);
		$('#excel').attr("checked",false);
		$('#reporte').val(1);
	});
	
	$('#excel').click(function() {
		$('#excel').focus();
		$('#excel').attr("checked",true);
		$('#pdf').attr("checked",false);
		$('#pantalla').attr("checked",false);
		$('#reporte').val(3);
	});
	$('#sucursalID').val(parametroBean.sucursal);
	validaSucursal1();
	
	$('#sucursalID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('sucursalID', '2', '4', 'nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');
	});
			
	$('#clienteID').bind('keyup',function(e) {
		lista('clienteID', '2', '1', 'nombreCompleto',$('#clienteID').val(),'listaCliente.htm');
	});
	
	$('#sucursalID').blur(function() { 
		if($('#sucursalID').asNumber()==0 ||$('#sucursalID').val()=="" ){
			if($('#clienteID').asNumber()==0 ||$('#clienteID').val()=="") {
				$('#sucursalID').val(parametroBean.sucursal);
				validaSucursal1();
			}else{
				$('#sucursalID').val('0');
				$('#nombreSucursal').val('TODAS');
			}
		}else{
			validaSucursal1();
		}
	});
	
	$('#clienteID').blur(function() {
		if($('#clienteID').asNumber()=='0'||$('#clienteID').asNumber()==''){
			if($('#sucursalID').asNumber()==0 ||$('#sucursalID').val()=="") {
				$('#nombreCte').val('TODOS');
				$('#sucursalID').val(parametroBean.sucursal);
				validaSucursal1();
			}else{
				$('#clienteID').val('0');
				$('#nombreCte').val('TODOS');
			}
			
		}else{
			consultaCliente(this.id);
		}
	});
	
	$('#imprimir').click(function() {
		var tipoReporte = $('#reporte').val();
		var nombreInstitucion =  parametroBean.nombreInstitucion;
		var nombreUsuario = parametroBean.claveUsuario;

		var sucursalID="";
		if($('#sucursalID').val()=="0"||$('#sucursalID').val()==""){
			sucursalID=parametroBean.sucursal;
		}else{
			sucursalID=$('#sucursalID').val();
		}
		var nombreSucursal= caracteresEspeciales($('#nombreSucursal').val());
		var fechaAc = parametroBean.fechaSucursal;
		var numCliente = $('#clienteID').val();
		var nomCliente = caracteresEspeciales($('#nombreCte').val());
		
		$('#ligaImp').attr('href','InverClientes.htm?clienteID='+numCliente+'&nombreCliente='+nomCliente+
				'&tipoReporte='+tipoReporte+'&fechaActual='+fechaAc+
				'&nombreUsuario='+nombreUsuario+'&nombreInstitucion='+nombreInstitucion+'&sucursalID='+sucursalID+
				'&nombreSucursal='+nombreSucursal); 
	});

	function consultaCliente(idControl) {
		var jqCliente  = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var conCliente =1;
		var rfc = ' ';
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCliente == '' || numCliente == 0){
			$('#clienteID').val(0);	
			$('#nombreCte').val('TODOS');												
		}else
		if(numCliente != '' && !isNaN(numCliente)){
			clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
				if(cliente!=null){
						$('#nombreCte').val(cliente.nombreCompleto);						
				}else{
					mensajeSis("No Existe el Cliente");
					$(jqCliente).focus();
					$(jqCliente).val('0');
					$('#nombreCte').val('TODOS');
				}    						
			});
		}
	}
	
	//Consulta el Nombre de La Sucursal Inicial
	function validaSucursal1() {
		var principal=1;
		var numSucursal = $('#sucursalID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numSucursal != '' && !isNaN(numSucursal)){
			sucursalesServicio.consultaSucursal(principal,numSucursal,function(sucursal) { 
				if(sucursal!=null){
						$('#nombreSucursal').val(sucursal.nombreSucurs);					
				}else{
					mensajeSis("No Existe la Sucursal");
					$('#sucursalID').focus();
					$('#sucursalID').val(parametroBean.sucursal);
					validaSucursal1();
				} 
			});
		}
	}
	
	//cambiar Caracteres especiales
	function caracteresEspeciales(cadena){
	   	// Se cambia las letras por valores URL
	   	cadena = cadena.replace(/á/gi,"%c1");
	   	cadena = cadena.replace(/é/gi,"%c9");
	   	cadena = cadena.replace(/í/gi,"%cd");
	   	cadena = cadena.replace(/ó/gi,"%d3");
	  	cadena = cadena.replace(/ú/gi,"%da");
	  	cadena = cadena.replace(/&/gi,"%26");
	   	return cadena;
	}
});
