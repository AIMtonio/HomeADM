$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	
	parametroBean = consultaParametrosSession();	
	var catTipoRepOpVentanilla = { 
			
			'PDF'		: 2,
			'Excel'		: 3 
	};
	
//------------ Metodos y Manejo de Eventos -----------------------------------------
	
	agregaFormatoControles('formaGenerica');
	consultaSucursal();	
	$('#fechaIni').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);
	
	$('#pdf').attr("checked",true) ; 
	$('#comercial').attr("checked",true);
	$('#fechaIni').focus();
	
	$(':text').focus(function() {	
		esTab = false;
	});


	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
		
	$('#fechaIni').change(function(){
		var Xfecha= $('#fechaIni').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaIni').val(parametroBean.fechaSucursal);
			var Yfecha= parametroBean.fechaAplicacion;
			if( mayor(Xfecha, Yfecha)){
				alert("La Fecha Inicial es Mayor a la Fecha del Sistema")	;
				$('#fechaIni').val(parametroBean.fechaSucursal);
				$('#fechaFin').val(parametroBean.fechaSucursal);
				regresarFoco('fechaIni');
			}else{
				if(!esTab){
					regresarFoco('fechaIni');
				}
				$('#fechaFin').val($('#fechaIni').val());
			}
		}else{
			$('#fechaIni').val(parametroBean.fechaSucursal);
			regresarFoco('fechaIni');
		}
	});
	
	$('#fechaFin').change(function() {
		var Xfecha= $('#fechaIni').val();
		var Yfecha= $('#fechaFin').val();
		var Zfecha= parametroBean.fechaSucursal;
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaFin').val($('#fechaIni').val());
			if(mayor(Yfecha,Zfecha)){
				alert("La Fecha Final es Mayor a la Fecha del Sistema");				
				regresarFoco('fechaFin');
				$('#fechaFin').val($('#fechaIni').val());
			}else{
				if(mayor(Xfecha, Yfecha)){
					alert("La Fecha Inicial es Mayor a la Fecha de Final");				
					regresarFoco('fechaFin');
					$('#fechaFin').val($('#fechaIni').val());
				}else{
					if(!esTab){
						regresarFoco('fechaFin');
					}
				}
			}
		}else{
			$('#fechaFin').val($('#fechaIni').val());
			regresarFoco('fechaFin');
		}
	});
	
	//Regresar el foco a un campo de texto.
	function regresarFoco(idControl){
		var jqControl=eval("'#"+idControl+"'");
		setTimeout(function(){
			$(jqControl).focus();
		 },0);
	}
	
	$('#cajaID').bind('keyup',function(e) {
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "cajaID";
			camposLista[1] = "sucursalID";
			parametrosLista[0] = $('#cajaID').val();
			parametrosLista[1] = $('#sucursal').val();
			lista('cajaID', '1', '6', camposLista, parametrosLista, 'listaCajaVentanilla.htm');
		}
	});
	$('#cajaID').blur(function() {
		consultaCaja(this.id);
		
	});
	$('#sucursal').change(function(){
		if(this.value == 0){
			$('#cajaID').val(0);
			$('#nombreCaja').val('TODAS');
		}else{
			$('#cajaID').val(0);
			$('#nombreCaja').val('TODAS');	
		}
	});
	
	$('#generar').click(function() { 		
		if($('#pdf').is(":checked") && $('#contable').is(':checked')){
			generaPDF();
		}else if($('#pdf').is(":checked") && $('#comercial').is(':checked')){
			generaPDFC();
		}else if ($('#excel').is(":checked") && $('#contable').is(':checked')){			
			generaExcel();
		}else if($('#excel').is(":checked") && $('#comercial').is(':checked')){
			generaExcelComer();			
		}	

	});


	
	
	function generaExcel() {		
		$('#pdf').attr("checked",false) ;
		$('#pantalla').attr("checked",false); 
		if($('#excel').is(':checked')){	
			var tr= 3;   
			var fechaIni = $('#fechaIni').val();	 
			var fechaFin = $('#fechaFin').val();	
			var usuario = 	parametroBean.claveUsuario;
			var fechaEmision = parametroBean.fechaSucursal;			
			var naturaleza= $('#naturaleza').val();
			var nomCaja= $('#nombreCaja').val();
			var nomSucursal= $('#sucursal option:selected').text();
			
			/// VALORES TEXTO
			//var nombreUsuario = parametroBean.nombreUsuario; 
			var nombreInstitucion =  parametroBean.nombreInstitucion; 
			var sucursal =$('#sucursal').val();
			var caja =$('#cajaID').val();

            $('#ligaGenerar').attr('href','repOpVentanilla.htm?fechaIni='+fechaIni+'&fechaFin='+
					fechaFin+'&usuario='+usuario+'&tipoReporte='+tr+'&fecha='+fechaEmision+
					'&nombreInstitucion='+nombreInstitucion+'&sucursalID='+sucursal+'&cajaID='+caja+'&naturaleza='+naturaleza+
					'&descripcionCaja='+nomCaja+'&nombreSucursal='+nomSucursal);
			
		}
	}

	function generaPDF() {	
		if($('#pdf').is(':checked')){	
			$('#pantalla').attr("checked",false); 
			$('#excel').attr("checked",false); 
			var tr= 2; 
			var fechaIni = $('#fechaIni').val();	 
			var fechaFin = $('#fechaFin').val();	
			var usuario = 	parametroBean.claveUsuario;
			var fechaEmision = parametroBean.fechaSucursal;
			var naturaleza= $('#naturaleza').val();
			var nomCaja= $('#nombreCaja').val();
			var nomSucursal= $('#sucursal option:selected').text();
			
			/// VALORES TEXTO
			var nombreUsuario = parametroBean.nombreUsuario; 
			var nombreInstitucion =  parametroBean.nombreInstitucion; 
			var sucursal =$('#sucursal').val();
			var caja =$('#cajaID').val();

			$('#ligaGenerar').attr('href','repOpVentanilla.htm?fechaIni='+fechaIni+'&fechaFin='+
					fechaFin+'&usuario='+usuario+'&tipoReporte='+tr+'&fecha='+fechaEmision+
					'&nombreInstitucion='+nombreInstitucion+'&sucursalID='+sucursal+'&cajaID='+caja+'&naturaleza='+naturaleza+
					'&descripcionCaja='+nomCaja+'&nombreSucursal='+nomSucursal);	
		}
	}
	
	function generaPDFC() {	
		if($('#pdf').is(':checked')){	
			$('#pantalla').attr("checked",false); 
			$('#excel').attr("checked",false); 
			var tr= 4; 
			var fechaIni = $('#fechaIni').val();	 
			var fechaFin = $('#fechaFin').val();	
			var usuario = 	parametroBean.claveUsuario;
			var fechaEmision = parametroBean.fechaSucursal;
			var naturaleza= $('#naturaleza').val();
			var nomCaja= $('#nombreCaja').val();
			var nomSucursal= $('#sucursal option:selected').text();
			
			/// VALORES TEXTO
			var nombreUsuario = parametroBean.nombreUsuario; 
			var nombreInstitucion =  parametroBean.nombreInstitucion; 
			var sucursal =$('#sucursal').val();
			var caja =$('#cajaID').val();
			$('#ligaGenerar').attr('href','repOpVentanilla.htm?fechaIni='+fechaIni+'&fechaFin='+
					fechaFin+'&usuario='+usuario+'&tipoReporte='+tr+'&fecha='+fechaEmision+
					'&nombreInstitucion='+nombreInstitucion+'&sucursalID='+sucursal+'&cajaID='+caja+'&naturaleza='+naturaleza+
					'&descripcionCaja='+nomCaja+'&nombreSucursal='+nomSucursal);
			
		}
	}
	
	function generaExcelComer() {		
		$('#pdf').attr("checked",false) ;
		$('#pantalla').attr("checked",false); 
		if($('#excel').is(':checked')){	
			var tr= 5;   
			var fechaIni = $('#fechaIni').val();	 
			var fechaFin = $('#fechaFin').val();	
			var usuario = 	parametroBean.claveUsuario;
			var fechaEmision = parametroBean.fechaSucursal;			
			var naturaleza= $('#naturaleza').val();
			var nomCaja= $('#nombreCaja').val();
			var nomSucursal= $('#sucursal option:selected').text();
			/// VALORES TEXTO
			//var nombreUsuario = parametroBean.nombreUsuario; 
			var nombreInstitucion =  parametroBean.nombreInstitucion; 
			var sucursal =$('#sucursal').val();
			var caja =$('#cajaID').val();

            $('#ligaGenerar').attr('href','repOpVentanilla.htm?fechaIni='+fechaIni+'&fechaFin='+
					fechaFin+'&usuario='+usuario+'&tipoReporte='+tr+'&fecha='+fechaEmision+
					'&nombreInstitucion='+nombreInstitucion+'&sucursalID='+sucursal+'&cajaID='+caja+'&naturaleza='+naturaleza+
					'&descripcionCaja='+nomCaja+'&nombreSucursal='+nomSucursal);
			
		}
	}
	
	function consultaSucursal(){
		var tipoCon=2;
		
		dwr.util.removeAllOptions('sucursal');
		dwr.util.addOptions( 'sucursal', {'0':'TODAS'});
		sucursalesServicio.listaCombo(tipoCon, function(sucursales){
			dwr.util.addOptions('sucursal', sucursales, 'sucursalID', 'nombreSucurs');						
		if(parametroBean.tipoCaja == 'CP'){
		     $('#sucursal').val(parametroBean.sucursal).selected = true;
		  deshabilitaControl('sucursal');		 
		 	  
		}
		else{
		  if(parametroBean.tipoCaja == 'CA'){
		     $('#sucursal').val(parametroBean.sucursal).selected = true;
		     $('#cajaID').val(parametroBean.cajaID);
		     $('#cajaID').blur();
		    deshabilitaControl('sucursal');
		    deshabilitaControl('cajaID');
		  }
		}
		});
		


	}
	
	function consultaCaja(idControl){//pregunta tambien la accesibilidad extructural
		var jqCajaVentanilla = eval("'#" + idControl + "'");
		var numCajaID = $(jqCajaVentanilla).val();
		var conPrincipal = 1;		// es una consulta Con_CajasTransfer 
		var numSucID =$('#sucursal').val();
		var CajasVentanillaBeanCon = {
  			'cajaID': numCajaID
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCajaID == ''|| numCajaID == 0){
			$('#cajaID').val(0);
			$('#nombreCaja').val('TODAS');
		}else{
		if(numCajaID != '' && !isNaN(numCajaID)){
			if (numSucID==0){
				alert('seleccione una sucursal');
				$('#cajaID').val(0);
				$('#nombreCaja').val('TODAS');
				
			}
			cajasVentanillaServicio.consulta(conPrincipal, CajasVentanillaBeanCon ,function(cajasVentanilla){
				if(cajasVentanilla != null){
					  if(cajasVentanilla.sucursalID==$('#sucursal option:selected').val()){
					     $("#nombreCaja").val(cajasVentanilla.descripcionCaja);
					  }else{
							alert("La Caja no corresponde con la Sucursal");
							$('#cajaID').val(0);
							$('#nombreCaja').val('TODAS');
							$('#cajaID').focus();
					  	}
					
				}else{
						alert('La caja no existe');
					}
				
			});	
		   }
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
	
});
	