$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	var parametroBean = consultaParametrosSession();   

	var catTipoRepRompimientos = { 
			'PDF'	: 1
	};	
	
	var catTipoConRompGrupo = {
			'rompimiento' : 11
	};
	
	var catTipoconSucursal= {
			'sucursal' :2
	};
	
	var catTipoConsultaUsuario = {
			'principal' : 1
	};
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	
	
	$('#pdf').attr("checked",true) ; 

	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaVencimiento').val(parametroBean.fechaSucursal);

	$(':text').focus(function() {	
		esTab = false;
	});
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	 $('#grupoID').bind('keyup',function(e){
		 if(this.value.length >= 2){ 
			var camposLista = new Array(); 
		    var parametrosLista = new Array(); 
		    	camposLista[0] = "nombreGrupo";
		    	parametrosLista[0] = $('#grupoID').val();
		 listaAlfanumerica('grupoID', '2', '2', camposLista, parametrosLista, 'listaGruposCredito.htm'); }
	 });
	 
	 $('#grupoID').blur(function() { 
			validaGrupo(this.id);
	 });
			 
	 
	$('#sucursalID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('sucursalID', '2', '4', 'nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');
	});
		
	$('#sucursalID').blur(function() {
		consultaSucursal(this.id);
	}); 

	$('#usuarioID').bind('keyup',function(e){
		lista('usuarioID', '2', '1', 'nombreCompleto', $('#usuarioID').val(), 'listaUsuarios.htm');
	});
	
	$('#usuarioID').blur(function() {
		consultaUsuario(this.id);
	});	
	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		$('#fechaInicio').focus();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaVencimiento').val();
			if (mayor(Xfecha, Yfecha))
			{
				alert("La Fecha de Inicio no debe ser mayor a la Fecha Fin.");
				$('#fechaInicio').val(parametroBean.fechaSucursal);
				$('#fechaInicio').focus();
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
			$('#fechaInicio').focus();
		}
	});

	$('#fechaVencimiento').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaVencimiento').val();
		$('#fechaVencimiento').focus();
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaVencimiento').val(parametroBean.fechaSucursal);
			if (mayor(Xfecha, Yfecha))
			{
				alert("La Fecha Fin no debe ser menor a la Fecha Inicio.");
				$('#fechaVencimiento').val(parametroBean.fechaSucursal);
				$('#fechaVencimiento').focus();
			}
		}else{
			$('#fechaVencimiento').val(parametroBean.fechaSucursal);
			$('#fechaVencimiento').focus();
		}
	});
	
	$('#generar').click(function() { 
			generaPDF();
	});
	
	$('#formaGenerica').validate({
		rules: {			
			fechaInicio: {
				required: true,
			},
			fechaVencimiento:{
				required: true,
			}
		},		
		messages: {
			fechaInicio: {
				required: 'Especifique Fecha Inicio'

			},
			fechaVencimiento:{
				required: 'Especifique Fecha Fin'
			}
		}
	});

	// ***********  Inicio  validacion   ***********
	
	// Funcion para consultar rompimiento de grupos
	function validaGrupo(idControl){
		var jqGrupo  = eval("'#" + idControl + "'");
		var grupo = $(jqGrupo).val();	 
		
		var grupoBeanCon = { 
				'grupoID':grupo
		};	
		setTimeout("$('#cajaLista').hide();", 200);
		if(grupo == '' || grupo==0){
			$(jqGrupo).val(0);
			$('#nombreGrupo').val('TODOS');
			limpiaFormulario();
		}
		else
		if(grupo != '' && !isNaN(grupo) && esTab){
			gruposCreditoServicio.consulta(catTipoConRompGrupo.rompimiento,grupoBeanCon,function(grupos) {
			if(grupos!=null){
				$('#nombreGrupo').val(grupos.nombreGrupo);
				$('#sucursalID').val(grupos.sucursalID);
				consultaSucursal('sucursalID');
				$('#usuarioID').val(grupos.usuario);
				consultaUsuario('usuarioID');	
			}
			else{
				alert("No Existe Grupo en Rompimiento");
				$(jqGrupo).focus();
				$(jqGrupo).val(0);
				$('#nombreGrupo').val('TODOS');	
				limpiaFormulario();
			}
			});		
		}
   }
	
	// Funcion para Consultar Sucursal
	function consultaSucursal(idControl) {
		var jqSucursal = eval("'#" + idControl + "'");
		var numSucursal = $(jqSucursal).val();	
		
		setTimeout("$('#cajaLista').hide();", 200);	
		if(numSucursal == '' || numSucursal==0){
			$(jqSucursal).val(0);
			$('#nombreSucursal').val('TODOS');
		}
		else
		if(numSucursal != '' && !isNaN(numSucursal)){
			sucursalesServicio.consultaSucursal(catTipoconSucursal.sucursal,numSucursal,function(sucursal) {
				if(sucursal!=null){	
					$('#sucursalID').val(sucursal.sucursalID);		
					$('#nombreSucursal').val(sucursal.nombreSucurs);

				}else{
					alert("No Existe la Sucursal");
					$('#sucursalID').focus();
					$(jqSucursal).val(0);
					$('#nombreSucursal').val('TODOS');
				}    						
			});
		}
	}
	
	// Funcion para Consultar Usuario
	function consultaUsuario(idControl) {
		var jqUsuario = eval("'#" + idControl + "'");
		var numUsuario = $(jqUsuario).val();	
		var usuarioBeanCon = {
  				'usuarioID':numUsuario 
				};	
		setTimeout("$('#cajaLista').hide();", 200);
		if(numUsuario == '' || numUsuario==0){
			$(jqUsuario).val(0);
			$('#nombreUsuario').val('TODOS');
		}
		else	
		if(numUsuario != '' && !isNaN(numUsuario) && esTab){
			usuarioServicio.consulta(catTipoConsultaUsuario.principal,usuarioBeanCon,function(usuario) {
					if(usuario!=null){							
						$('#nombreUsuario').val(usuario.nombreCompleto);
					}else{
						
						alert("No Existe el Usuario");
						$(jqUsuario).focus();
						$(jqUsuario).val(0);
						$('#nombreUsuario').val("TODOS");	
					}  
			});
		}
	}
	// Funcion para genera en PDF el reporte de rompimientos
	function generaPDF() {	
		if($('#pdf').is(':checked')){	
			var tr= catTipoRepRompimientos.PDF; 
			var fechaInicio = $('#fechaInicio').val();	 
			var fechaFin = $('#fechaVencimiento').val();
			var grupo = $('#grupoID').val();
			var sucursal = $('#sucursalID').val();
			var usuario = $('#usuarioID').val();
			var fechaEmision = parametroBean.fechaSucursal;
			
			/// VALORES TEXTO
			var nombreGrupo = $('#nombreGrupo').val();
			var nombreSucursal = $('#nombreSucursal').val();
			var nombreUsuario =$('#nombreUsuario').val();
		
			var nombreInstitucion =  parametroBean.nombreInstitucion; 
			var nomUsuario = parametroBean.nombreUsuario; 

			$('#ligaGenerar').attr('href','rompimientoGrupoRep.htm?fechaInicio='+fechaInicio+'&fechaVencimiento='+fechaFin+
					'&grupoID='+grupo+'&sucursalID='+sucursal+'&tipoReporte='+tr+'&usuarioID='+usuario+'&fechaActual='+fechaEmision+
					'&nombreGrupo='+nombreGrupo+'&nombreSucursal='+nombreSucursal+'&nombreUsuario='+nombreUsuario+
					'&nombreInstitucion='+nombreInstitucion+'&nomUsuario='+nomUsuario
			);
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
				alert("Formato de fecha no válido (aaaa-mm-dd)");
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

function limpiaFormulario(){
	$('#sucursalID').val('');
	$('#nombreSucursal').val('');
	$('#usuarioID').val('');
	$('#nombreUsuario').val('');
}