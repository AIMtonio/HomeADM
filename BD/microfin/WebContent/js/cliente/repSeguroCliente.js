$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;

	var parametroBean = consultaParametrosSession();   

		

	var catTipoRepVencimientos = { 
		
			'PDF'		: 1,
		
	};	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	consultaSucursal();


	$('#pdf').attr("checked",true) ; 




	$(':text').focus(function() {	
		esTab = false;
	});


	$('#promotorID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('promotorID', '1', '1', 'nombrePromotor',
				$('#promotorID').val(), 'listaPromotores.htm');
	});	

	$('#pdf').click(function() {
		if($('#pdf').is(':checked')){	
			$('#tdPresenacion').show('slow');
		}
	});

$('#clienteID').blur(function() {
		consultaCliente(this.id);

	});
	$('#promotorID').blur(function() {
		consultaPromotorI(this.id);

	});

	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaFin').val();
			if ( mayor(Xfecha, Yfecha) )
			{
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});

	$('#fechaFin').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaFin').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaFin').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) )
			{
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}

	});



	$('#generar').click(function() { 

		if($('#pdf').is(":checked") ){
			generaPDF();
		}


	});


	// ***********  Inicio  validacion Promotor ***********

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
			$('#nombrePromotorI').val('TODOS');
		}
		else	

			if(numPromotor != '' && !isNaN(numPromotor) ){ 
				promotoresServicio.consulta(tipConForanea,promotor,function(promotor) { 
					if(promotor!=null){							
						$('#nombrePromotorI').val(promotor.nombrePromotor); 

					}else{
						alert("No Existe el Promotor");
						$(jqPromotor).val(0);
						$('#nombrePromotorI').val('TODOS');
					}    	 						
				});
			}
	}
	
	
	
	function consultaCliente(idControl) {
		var jqCliente  = eval("'#" + idControl + "'");
		var varclienteID = $(jqCliente).val();	
		var conCliente =5;
		var rfc = ' ';
		setTimeout("$('#cajaLista').hide();", 200);		
		if(varclienteID != '' && !isNaN(varclienteID)){
			clienteServicio.consulta(conCliente,varclienteID,rfc,function(cliente){
						if(cliente!=null){
							if(cliente.estatus!='I'){
							$('#clienteID').val(cliente.numero);
							var tipo = (cliente.tipoPersona);
							if(tipo=="F"){
								$('#nombreCliente').val(cliente.nombreCompleto);
							}
							if(tipo=="M"){
								$('#nombreCliente').val(cliente.razonSocial);
							}
							if(tipo=="A"){
								$('#nombreCliente').val(cliente.nombreCompleto);
							}
							}
							else{
								alert("El cliente esta Inactivo");
								$(jqCliente).focus();
								//$(jqCliente).select();
								$('#clienteID').val('');
								$('#nombreCliente').val('');
							}
						}else{
							alert("No Existe el Cliente");
							$(jqCliente).focus();
							$(jqCliente).select();
						}    						
				});
			}
	}	

		// fin validacion Promotor



	function consultaSucursal(){
		var tipoCon=2;
		dwr.util.removeAllOptions('sucursal');
		dwr.util.addOptions( 'sucursal', {'0':'Todas'});
		sucursalesServicio.listaCombo(tipoCon, function(sucursales){
			dwr.util.addOptions('sucursal', sucursales, 'sucursalID', 'nombreSucurs');
		});
	}
	

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);


$('#clienteID').bind('keyup',function(e) { 
		lista('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

	function generaPDF() {	
		if($('#pdf').is(':checked')){	
		 
			var tr= catTipoRepVencimientos.PDF; 
			var fechaInicio = $('#fechaInicio').val();	 
			var fechaFin = $('#fechaFin').val();	
			var clienteID =$('#clienteID').val();
			var sucursal = $("#sucursal option:selected").val();
			var promotorID = $('#promotorID').val();
			var estatus = $('#estatus').val();
			var fechaEmision = parametroBean.fechaSucursal;
			var usuario = 	parametroBean.claveUsuario;
		
		
		
			
			/// VALORES TEXTO
			var nombreCliente = $('#nombreCliente').val();
			var nombreSucursal = $("#sucursal option:selected").val();
			var nombreUsuario = parametroBean.claveUsuario; 
			var nombrePromotor = $('#nombrePromotorI').val();
			var nombreInstitucion =  parametroBean.nombreInstitucion; 

			if(nombreSucursal=='0'){
				nombreSucursal='';
			}
			else{
				nombreSucursal = $("#sucursal option:selected").html();
			}

			if(nombreCliente=='0'){
				nombreCliente='';
			}else{
				nombreCliente = $("#clienteID option:selected").html();
			}

			$('#ligaGenerar').attr('href','repSeguroCliente.htm?fechaInicio='+fechaInicio+'&fechaFin='+
					fechaFin+'&clienteID='+clienteID+'&sucursal='+sucursal+
					'&promotor='+promotorID+'&estatus='+estatus+	
					'&nombreCliente='+nombreCliente+'&nombreSucursal='+nombreSucursal+
					'&nombrePromotor='+nombrePromotor+'&parFechaEmision='+fechaEmision+
					'&usuario='+usuario+'&nombreUsuario='+nombreUsuario+
					'&nombreInstitucion='+nombreInstitucion);
		}
	}




//	VALIDACIONES PARA LAS PANTALLAS DE REPORTE

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
//	FIN VALIDACIONES DE REPORTES

	/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				alert("formato de fecha no válido (aaaa-mm-dd)");
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
				if (comprobarSiBisisesto(anio)){ numDias=29 }else{ numDias=28};
				break;
			default:
				alert("Fecha introducida errónea");
			return false;
			}
			if (dia>numDias || dia==0){
				alert("Fecha introducida errónea");
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
	/***********************************/


});
