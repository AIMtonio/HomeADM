var parametrosBean = consultaParametrosSession();
var alertSocio = $('#alertSocio').val();
$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	var Desc_Reporte = 'Reporte de Usuarios de Servicio';
	
	$('#fecha').val(parametroBean.fechaSucursal);
	
	var catReporteUsuarioServicio = { 
			'PDF'		: 1,
			'Excel'		: 2 	
		};
	
//------------ Metodos y Manejo de Eventos -----------------------------------------
	
	agregaFormatoControles('formaGenerica');
	consultaSucursal(0);
	
	$('#pdf').attr("checked",true) ; 
	$('#usuarioID').focus();
	
	$(':text').focus(function() {	
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	$('#generar').click(function(){
	 		if($('#pdf').is(':checked')){			
				generaReporte(catReporteUsuarioServicio.PDF);			
			}
			if($('#excel').is(':checked')){			
				generaReporte(catReporteUsuarioServicio.Excel);		
			}		
	});
	

	inicializaLimpia('formaGenerica');
	//Seccion Datos Usuario
	
	$('#usuarioID').bind('keyup',function(e) { 
		lista('usuarioID', '3', '1', 'nombreCompleto', $('#usuarioID').val(), 'listaUsuario.htm');
	});
	
	
	$('#sucursalID').blur(function (){
		setTimeout("$('#cajaLista').hide();", 200);
		consultaSucursal(this.value);
	});
	
	$('#sucursalID').bind('keyup',function(e) {
		lista('sucursalID', '2', '1', 'nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');	
	});
	
	$('#usuarioID').blur(function() {
		setTimeout("$('#cajaListaCte').hide();", 200);
		consultaUsuario(this.value);

	});


	function inicializaLimpia(limforma) {
		
		}
	function consultaUsuario(usuarioID){
		var conPrincipal = 1;
		var usuarioBean = {
			'usuarioID' : usuarioID
		};
		if(usuarioID == '0'){
			$('#desUsuarioID').val('TODOS');
			habilitaControl('sucursalID');
			habilitaControl('desSucursal');
			habilitaControl('sexo');
			$('#sucursalID').val('0');
			$('#desSucursal').val('TODAS');
			$('#sexo').val('');
		}else{
			if(usuarioID != '' && !isNaN(usuarioID)){
			usuarioServicios.consulta(conPrincipal,usuarioBean,function(usuario){
				if (usuario != null){
						$('#usuarioID').val()
						$('#desUsuarioID').val(usuario.nombreCompleto);	
						$('#sucursalID').val(usuario.sucursalOrigen);	
						consultaSucursal($('#sucursalID').val());
						$('#sexo').val(usuario.sexo);
						deshabilitaControl('sucursalID');
						deshabilitaControl('desSucursal');
						deshabilitaControl('sexo');
					}
				else{
					alert('No Existe el Usuario');
					$('#desUsuarioID').val('');
					$('#usuarioID').focus();
				}
			});
		}
		}
		
	}
function consultaSucursal(sucursalID) {	
			var tipoConsulta = 2;
			var CajasBeanCon1 = {
  			   'sucursalID':sucursalID
			 };
			
		if(sucursalID == '0'){
			$('#desSucursal').val('TODAS');
		}else{
			if (sucursalID != '' && !isNaN(sucursalID)) {			
					sucursalesServicio.consultaSucursal(tipoConsulta,sucursalID, function(sucursal) {
						if (sucursal != null) {
							$('#sucursalID').val();	
							$('#desSucursal').val(sucursal.nombreSucurs);
							
						} else {							
							alert("La sucursal No Existe.");
							$('#sucursalID').val('');	
							$('#desSucursal').val('');	
							$('#sucursalID').focus();	
						}
					});
			}else{ 
				
				$('#sucursalID').val('');
				$('#desSucursal').val('');
				$('#sucursalID').focus();	
			}

		}
			
	}
	// FIN SERVICIOS 			
		
	//Regresar el foco a un campo de texto.
	function regresarFoco(idControl){
		var jqControl=eval("'#"+idControl+"'");
		setTimeout(function(){
			$(jqControl).focus();
		 },0);
	}

	
	function generaReporte(tipoReporte){
		var nombreInstitucion = parametroBean.nombreInstitucion;
		var nombreUsuario = parametroBean.claveUsuario; 
		var fechaSis = parametroBean.fechaSucursal;
		var etiquetaSocio= alertSocio;
		var desSexo=$('#sexo').val();
		var url='';
		if(desSexo==""){
			desSexo="TODOS";
		}
		if (desSexo=="F"){
			desSexo="FEMENINO";
			}
		else if(desSexo=="M"){
			desSexo="MASCULINO";
		}
		
		if($('#pdf').is(':checked')){
			url ='usuarioServicioRep.htm?tipoReporte=' + tipoReporte+'&nombreInstitucion='+nombreInstitucion+"&nomReporte="+Desc_Reporte+"&usuarioID="+$('#usuarioID').val()+"&sucursalID="+$('#sucursalID').val()
			+"&descSucursal="+$('#desSucursal').val()+"&sexo="+$('#sexo').val()+"&nombreUsuario="+nombreUsuario+"&fechaSistema="+fechaSis+'&etiquetaSocio='+etiquetaSocio+"&desUsuarioID="+$('#desUsuarioID').val()+'&desSexo='+desSexo;
			   window.open(url);
		}
		
		if($('#excel').is(':checked')){
				url ='usuarioServicioRep.htm?tipoReporte=' + tipoReporte+'&nombreInstitucion='+nombreInstitucion+"&nomReporte="+Desc_Reporte+"&usuarioID="+$('#usuarioID').val()+"&sucursalID="+$('#sucursalID').val()
			+"&descSucursal="+$('#desSucursal').val()+"&sexo="+$('#sexo').val()+"&nombreUsuario="+nombreUsuario+"&fechaSistema="+fechaSis+'&etiquetaSocio='+etiquetaSocio+"&desUsuarioID="+$('#desUsuarioID').val();
			   window.open(url);
			}
		
	   };
		
});
	