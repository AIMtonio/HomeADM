$(document).ready(function() {
	parametros = consultaParametrosSession();

	// Declaración de constantes 
	var catTipoConsultaSolicitud = {  
	  		'principal'		: 8
		};	
		
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');				
	$('#fechaInicio').val(parametros.fechaSucursal);
	$('#fechaFin').val(parametros.fechaSucursal);
	$('#fechaInicio').focus();
	$('#promotorID').val(0);
	$('#nombrePromotor').val('TODOS');
	$('#productoCreditoID').val(0);
	$('#nombreProducto').val('TODOS');
	$('#excel').attr("checked",true) ; 
		
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
		}
	});	
	$('#sucursalID').val(parametroBean.sucursal);
	validaSucursal1();
	
	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Zfecha= parametroBean.fechaSucursal;
		if(esFechaValida(Xfecha)){
			if(Xfecha==''){
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
			if (mayor(Xfecha, Zfecha) ){
				mensajeSis("La Fecha Inicial es Mayor a la Fecha Actual.");
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
			
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});

	// se valida que la fecha de carga no sea superior a la fecha del sistema
	$('#fechaFin').change(function() {
		var Xfecha= parametroBean.fechaSucursal;
		var Yfecha= $('#fechaFin').val();
		var Zfecha= $('#fechaInicio').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha==''){
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
			if ( mayor(Yfecha,Xfecha) ){
				mensajeSis("La Fecha Final es mayor a la Fecha Actual.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
			if ( mayor(Zfecha,Yfecha) ){
				mensajeSis("La Fecha de Final es menor a la Fecha Inicial.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}
	});
	
	
	$('#sucursalID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('sucursalID', '2', '4', 'nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');
	});
	
	// eventos para producto de credito
	$('#producCreditoID').bind('keyup',function(e) {
		lista('producCreditoID', '2', '10','descripcion', $('#producCreditoID').val(),'listaProductosCredito.htm');
	});
	
	$('#usuarioID').bind('keyup',function(e){
		lista('usuarioID', '2', '1', 'nombreCompleto', $('#usuarioID').val(), 'listaUsuarios.htm');
	});
	
	$('#promotorID').bind('keyup',function(e){
		lista('promotorID', '1', '1', 'nombrePromotor',
				$('#promotorID').val(), 'listaPromotores.htm');
	});	
	
	$('#sucursalID').blur(function() {
		if($('#sucursalID').val()==""){
			$('#sucursalID').val(parametroBean.sucursal);
			validaSucursal1();
		} if($('#sucursalID').val()=="0"){
			$('#sucursalID').val("0");
			$('#nombreSucursal').val("TODAS");
		}
		else{
			validaSucursal1();
		}
	});
	
	$('#clienteID').blur(function() {
		if ($('#clienteID').asNumber()>0 && $.trim($('#clienteID').val()) != "" && esTab == true) {
			consultaCliente(this.id);
		} else {
			$('#clienteID').val(0);
			$('#nombreCliente').val('TODOS');
		}
	});
	$('#clienteID').bind('keyup',function(e) {
		lista('clienteID', '3', '12', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	
	$('#prospectoID').bind('keyup',function(e) {
		lista('prospectoID', '1', '1', 'prospectoID', $('#prospectoID').val(), 'listaProspecto.htm');
	});
	
	$('#prospectoID').blur(function() {
		if ($('#prospectoID').asNumber()>0 && $.trim($('#prospectoID').val()) != "" && esTab == true) {
			consultaProspecto(this.id);
		} else {
			$('#prospectoID').val(0);
			$('#nombreProspecto').val('TODOS');
		}
	});
	
	
	
	$('#producCreditoID').blur(function() {
		if($('#producCreditoID').val()=="0" || $('#producCreditoID').val()==""){
			$('#producCreditoID').val("0");
			$('#nombreProducto').val("TODOS");
		}else{
			consultaProducCredito(this.id);
		}
		
	});
	
	$('#usuarioID').blur(function() {
		if($('#usuarioID').val()=="0"||$('#usuarioID').val()==""){
			$('#usuarioID').val('0');
			$('#nombreUsuario').val('TODOS');
	  	}else{
	  		validaUsuario();
		}
	});	
	
	
	$('#promotorID').blur(function() {
		consultaPromotorI(this.id);

	});

	
	$('#generar').click(function() { 
		generaExcel();


	});	
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			solicitudCreditoID: 'required',
		},		
		messages: {
			solicitudCreditoID: 'Especifique el Número de Solicitud.',
		}		
	});
	
	

	//------------ Validaciones de Controles -------------------------------------
	
	//Consulta el Nombre de La Sucursal 
	function validaSucursal1() {
		var principal=1;
		numSucursal=$('#sucursalID').val();
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
			else{
				$('#sucursalID').val('0');
				$('#nombreSucursal').val('TODAS');
		   }
		}	
	
	
		//Consulta el Producto de Credito
	function consultaProducCredito(idControl) {				
		var jqProdCred  = eval("'#" + idControl + "'");
		var ProdCred = $(jqProdCred).val();			
		var ProdCredBeanCon = {
  			'producCreditoID':ProdCred 
		}; 
		setTimeout("$('#cajaLista').hide();", 200);
		if(ProdCred != '' && !isNaN(ProdCred)){		
			productosCreditoServicio.consulta(catTipoConsultaSolicitud.principal,ProdCredBeanCon,function(prodCred) {
				if(prodCred!=null){
					$('#nombreProducto').val(prodCred.descripcion);							
				}else{
					mensajeSis("El Producto de Crédito No es Agropecuario");
					$('#producCreditoID').val('0');	
					$('#nombreProducto').val('TODOS');	
					$(jqProdCred).focus();	
				}
			});
		}	
		else{
			$('#producCreditoID').val('0');	
			$('#nombreProducto').val('TODOS');	
		}			 					
	}  
	
	// Consulta promotores

	function consultaPromotorI(idControl) {
		var jqPromotor = eval("'#" + idControl + "'"); 
		var numPromotor = $(jqPromotor).val();	
		var tipConForanea = 2;	
		var promotor = {
				'promotorID' : numPromotor
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numPromotor == '' || numPromotor==0){
			$(jqPromotor).val(0);
			$('#nombrePromotor').val('TODOS');
		}
		else	

			if(numPromotor != '' && !isNaN(numPromotor) ){ 
				promotoresServicio.consulta(tipConForanea,promotor,function(promotor) { 
					if(promotor!=null){							
						$('#nombrePromotor').val(promotor.nombrePromotor); 

					}else{
						mensajeSis("No Existe el Promotor");
						$(jqPromotor).val(0);
						$('#nombrePromotor').val('TODOS');
					}    	 						
				});
			}
			else{
					$(jqPromotor).val(0);
					$('#nombrePromotor').val('TODOS');
			}  
	}

	
	//Funcion para Consultar Usuario
	function validaUsuario() {
		var numUsuario = $('#usuarioID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numUsuario != '' && !isNaN(numUsuario) && esTab){
			if(numUsuario=='0'){
				$('#usuarioID').val("0");
				$('#nombreUsuario').val("TODOS");
			} else {
				var usuarioBeanCon = {
						'usuarioID':numUsuario 
				};	
				usuarioServicio.consulta(catTipoConsultaSolicitud.principal,usuarioBeanCon,function(usuario) {
					if(usuario!=null){
						$('#nombreUsuario').val(usuario.nombreCompleto);
					}else{
						mensajeSis("No Existe el Usuario");
						$('#usuarioID').focus();
						$('#usuarioID').val('0');
						$('#nombreUsuario').val("TODOS");														
					}
				});			
			}							
		}
	}
	//Funcion para genera Reporte
	function generaExcel(){
		var tipoRep			= 1;
		var nombreInstitucion=parametroBean.nombreInstitucion;
		var fechaEmision = parametroBean.fechaSucursal;
		var claveUsuario=parametroBean.claveUsuario;
		var nomUsu	= parametroBean.nombreUsuario;
		var clienteID=$('#prospectoID').asNumber()>0?'-1':$('#clienteID').asNumber();
		var clienteNombre = $('#nombreCliente').val();
		var prospectoID=$('#clienteID').asNumber()>0?'-1':$('#prospectoID').asNumber();
		var prospectoNombre = $('#nombreProspecto').val();
		var estatus=$('#estatus').val();
		var estatusDesc=$("#estatus option:selected").text();
		var esAgropecuario= 'S';
		
		var paginaReporte ='RepBitacoraSol.htm?'+
			'tipoRep='+tipoRep+
			'&nombreInstitucion='+nombreInstitucion+
			'&fechaInicio='+$('#fechaInicio').val()+
			'&sucursalID='+$('#sucursalID').val()+
			'&usuario='+$('#usuarioID').val()+
			'&nombreSucursal='+$('#nombreSucursal').val()+
			'&nombreUsuario='+nomUsu+
			'&nomUsuario='+claveUsuario+
			'&fechaSistema='+fechaEmision+
			'&fechaFin='+$('#fechaFin').val()+
			'&producCreditoID='+$('#producCreditoID').val()+
			'&nombreProducto='+$('#nombreProducto').val()+
			'&clienteID='+clienteID+
			'&clienteNombre='+clienteNombre+
			'&prospectoID='+prospectoID+
			'&prospectoNombre='+prospectoNombre+
			'&promotorID='+$('#promotorID').val()+
			'&nombrePromotor='+$('#nombrePromotor').val()+
			'&estatus='+estatus+
			'&esAgropecuario='+esAgropecuario+
			'&estatusDesc='+estatusDesc;
			$('#ligaGenerar').attr('href',paginaReporte);
	}
	
	function mayor(fecha, fecha2){
		//0|1|2|3|4|5|6|7|8|9|
		//2 0 1 2 / 1 1 / 2 0
		var xMes=fecha.substring(5, 7);
		var xDia=fecha.substring(8, 10);
		var xAnio=fecha.substring(0,4);

		var yMes=fecha2.substring(5, 7);
		var yDia=fecha2.substring(8, 10);
		var yAnio=fecha2.substring(0,4);



		if (xAnio > yAnio){
			return true;
		}else{
			if (xAnio == yAnio){
				if (xMes > yMes){
					return true;
				}
				if (xMes == yMes){
					if (xDia > yDia){
						return true;
					}else{
						return false;
					}
				}else{
					return false;
				}
			}else{
				return false ;
			}
		} 
	}
	
	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("Formato de Fecha no Válido (aaaa-mm-dd)");
				return false;
			}

			var mes=  fecha.substring(5, 7)*1;
			var dia= fecha.substring(8, 10)*1;
			var anio= fecha.substring(0,4)*1;

			switch(mes){
			case 1: case 3:  case 5: case 7:
			case 8: case 10:
			case 12:
				numDias=31;
				break;
			case 4: case 6: case 9: case 11:
				numDias=30;
				break;
			case 2:
				if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
				break;
			default:
				mensajeSis("Fecha introducida errónea");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha introducida errónea");
				return false;
			}
			return true;
		}
	}
	function comprobarSiBisisesto(anio){
		if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
			return true;
		}
		else {
			return false;
		}
	}


	
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConForanea = 23;	
		setTimeout("$('#cajaLista').hide();", 200);		
		
		if(numCliente != '' && !isNaN(numCliente) && esTab){
			clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
					if(cliente!=null){
						$('#clienteID').val(cliente.numero)	;						
						$('#nombreCliente').val(cliente.nombreCompleto);
						$('#prospectoID').val('0');
						$('#nombreProspecto').val('TODOS');
					}else{
						clienteexiste = 1;
						mensajeSis("No Existe el "+$('#alertSocio').val()+".");
						$('#clienteID').val('0');
						$('#nombreCliente').val('TODOS');
						$('#prospectoID').val('0');
						$('#nombreProspecto').val('TODOS');
					}    	 						
				});
			}
		}	
});