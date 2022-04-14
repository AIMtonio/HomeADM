var opcionMenuRegBean ;
var menuGradoEst		= {};
var menuCargo			= {};
var menuManifest		= {};
var menuOrgano			= {};
var menuPermanente		= {};
var menuTipoMovimiento	= {};
var esTab				= true;
var enteroCero          = 0;
var catRegulatorioA1713 = { 
			'Excel'			: 2,		
			'Csv'			: 3,		
		};
 
var lisMenuRegulatorio = { 
			'Busqueda'		: 1,		
			'Combo'			: 2,		
		};

var catMenuRegulatorio = { 
			'GradoEst'			: 16,		
			'Cargo'				: 6,		
			'Manifest'			: 7,		
			'Organo'			: 8,
			'Permanente'		: 9,
			'TipoMovimiento'	: 17,
		}; 

$(document).ready(function() {
	parametros = consultaParametrosSession();
	esTab = true;

	$('#grabar').click(function(event){
		$('#tipoInstitID').val(6);
	});
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	var paramSesion = consultaParametrosSession();
	var fechaDeSistema = paramSesion.fechaSucursal;
	$('#fecha').val(fechaDeSistema);



	//------------ Validaciones de Controles -------------------------------------
	
	$.validator.setDefaults({
	    submitHandler: function(event) {
    	if(validarRegistro())
	    	{
	    		$('#tipoInstitID').val(6);
	    		grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','fecha');
					//Si la respuesta es éxitosa se habilita el botón generar	
	    	setTimeout(function(){
		  	   	var resultado = $('#numeroMensaje').val();
		  	   	 
				if(resultado == enteroCero){
				 	habilitaBoton('generar');
				}

	  	   },500);		  	    
	     
	    }
	    else
	    {
	    	return false;   	
	     
	  	
	  	  
	    }
	  	  
	  	   	 

	    }
	 });

	$('#formaGenerica').validate({
		rules: {
			fecha: 'required',
			

		},		
		messages: {
			fecha: 'Especifique  la fecha',	
			
		}		
	});
	

	cargarMenus(); 
	
	consultaRegistroRegulatorioA1713();

	$(':text').bind('keydown', function(e) {
				if (e.which == 9 && !e.shiftKey) {
					esTab = true;
				}
				

			});

	$(':text').focus(function() {
		esTab = false;
		
	});
	

	

});// cerrar


function consultaEstado(idControl) {
	var jqEstado = eval("'#" + idControl + "'");
	var numEstado = $(jqEstado).val();	
	var idfila= idControl.substr(8);
	var numPais =  $('#paisID'+idfila).val();
	
	var tipConForanea = 2;	
	setTimeout("$('#cajaLista').hide();", 200);		
	if(numEstado != ''  && !isNaN(numEstado)){
		estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
			if(estado!=null){							
				$('#des'+idControl).val(estado.nombre);
			}else{
				alert("No Existe el Estado");
				$('#estadoID'+ idfila).val("");
				$('#desestadoID'+ idfila).val("");
				$('#municipioID'+idfila).val("");
				$('#desmunicipioID'+idfila).val("");						
				$('#localidadID'+idfila).val("");
				$('#deslocalidadID'+idfila).val("");
				$('#coloniaDomicilioID'+idfila).val("");
				$('#descoloniaDomicilioID'+idfila).val("");
				$('#estadoID'+ idfila).focus();
				$('#estadoID'+ idfila).select();
			}    	 						
		});
	}
	else{
			if(numPais == ''){
				alert("Especificar Pais");
				$('#paisID'+ idfila).focus();
			}
		}

	

}
function buscaEstado(controlid){
	lista(controlid, '2', '1', 'nombre', $('#'+controlid).val(), 'listaEstados.htm');
	
} 
function consultaPais(idControl){
	var idfila= idControl.substr(6);
	var jqPais = eval("'#" + idControl + "'");
	var numPais = $(jqPais).val();
	var conPais = 3;

	
	if (numPais != '' && !isNaN(numPais)) {
		paisesServicio.consultaPaises(conPais, numPais,
			function(pais) {
				if (pais != null) {
					$('#des'+idControl).val(pais.nombre);
				} else {
					alert("No Existe el País");
					$('#paisID' + idfila).val("");
					$('#paisID' + idfila).focus();
					$('#paisID' + idfila).select();
					
				}
			});
	}
}

function consultaMunicipio(idControl) {
	var idfila= idControl.substr(11);
	var jqMunicipio = eval("'#" + idControl + "'");
	var numMunicipio = $(jqMunicipio).val();	
	var numEstado =  $('#estadoID'+idfila).val();
	var tipConForanea = 2;	

	var numPais =  $('#paisID'+idfila).val();
	setTimeout("$('#cajaLista').hide();", 200);		
	if(numMunicipio != '' && !isNaN(numMunicipio) && $(jqMunicipio).asNumber()>0){
		municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,function(municipio) {
					if(municipio!=null){							
						$('#desmunicipioID'+idfila).val(municipio.nombre);
																
					}else{
						alert("No Existe el Municipio");
						$('#municipioID'+idfila).val("");
						$('#desmunicipioID'+idfila).val("");						
						$('#localidadID'+idfila).val("");
						$('#deslocalidadID'+idfila).val("");
						$('#coloniaDomicilioID'+idfila).val("");
						$('#descoloniaDomicilioID'+idfila).val("");
						$('#municipioID'+idfila).focus();
						$('#municipioID'+idfila).select();
					}    	 						
			});
		}
		else{
			
			if(numPais == ''){
				alert("Especificar Pais");
				$('#paisID'+ idfila).focus();
			}
			else if(numEstado == '') {
				alert("Especificar Estado");
				$('#estadoID'+ idfila).focus();
			}
			
		}

	}
function buscaMunicipio(controlid){
		var idfila= controlid.substr(11);
	 
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "estadoID";
		camposLista[1] = "nombre";
		
		
		parametrosLista[0] = $('#estadoID'+idfila).val();
		parametrosLista[1] = $('#municipioID'+idfila).val();
		
		lista(controlid, '2', '1', camposLista, parametrosLista,'listaMunicipios.htm');
	
		

	
	
}
function consultaLocalidad(idControl) {
	var idfila= idControl.substr(11);

	var jqLocalidad = eval("'#" + idControl + "'");
	var numLocalidad = $(jqLocalidad).val();
	var numMunicipio =	$('#municipioID'+idfila).val();
	var numEstado =  $('#estadoID'+idfila).val();	
	var numPais =  $('#paisID'+idfila).val();				
	var tipConPrincipal = 3;	
	setTimeout("$('#cajaLista').hide();", 200);
	if(numLocalidad != '' && !isNaN(numLocalidad)){
		if(numEstado != '' && numMunicipio !=''){				
			localidadRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numLocalidad,function(localidad) {
				if(localidad!=null){	
					
					$('#deslocalidadID'+idfila).val(localidad.nombreLocalidad);
				}else{
					alert("No Existe la Localidad");
					$('#localidadID'+idfila).val("");
					$('#coloniaDomicilioID'+idfila).val("");
					$('#descoloniaDomicilioID'+idfila).val("");
					$('#localidadID'+idfila).focus();
					$('#localidadID'+idfila).select();
				}    	 						
			});
		}else{
			if(numPais == ''){
				alert("Especificar Pais");
				$('#paisID'+idfila).focus();
			}else if(numEstado == '')
			{
					alert("Especificar Estado");
				$('#estadoID'+idfila).focus();
			}
			else if(numMunicipio == '')
			{
				alert("Especificar Municipio");
				$('#municipioID'+idfila).focus();
			}
		}
		
	}
}
function buscaLocalidad(controlid){
	var idfila= controlid.substr(11);
	var camposLista = new Array();
	var parametrosLista = new Array();
	
	camposLista[0] = "estadoID";
	camposLista[1] = 'municipioID';
	camposLista[2] = "nombreLocalidad";
	
	
	parametrosLista[0] = $('#estadoID'+idfila).val();
	parametrosLista[1] = $('#municipioID'+idfila).val();
	parametrosLista[2] = $('#localidadID'+idfila).val();
	
	lista(controlid, '2', '2', camposLista, parametrosLista,'listaLocalidades.htm');
	
	
}

function buscaPais(controlid){
	lista(controlid, '3', '2', 'nombre', $('#'+controlid).val(), 'listaPaises.htm');
	
} 

function consultaColonia(idControl) {
		var idfila= idControl.substr(18);
		
		var jqColonia = eval("'#" + idControl + "'");
		var numColonia= $(jqColonia).val();		
		var numEstado =  $('#estadoID'+idfila).val();	
		var numMunicipio =	$('#municipioID'+idfila).val();
		var numLocalidad =	$('#localidadID'+idfila).val();
		var numPais =	$('#paisID'+idfila).val();
		var tipConPrincipal = 1;	
		
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numColonia != '' && !isNaN(numColonia)){
			coloniaRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numColonia,function(colonia) {
				if(colonia!=null){							
					$('#descoloniaDomicilioID'+idfila).val(colonia.asentamiento);
					$('#codigoPostal'+idfila).val(colonia.codigoPostal);
				}else{
					alert("No Existe la Colonia");
					$('#nombreColonia'+idfila).val("");
					$('#coloniaDomicilioID'+idfila).val("");
					$('#coloniaDomicilioID'+idfila).focus();
					$('#coloniaDomicilioID'+idfila).select();
				}    	 						
			});
		}
		else{
			
			if(numPais == ''){
				alert("Especificar Pais");
				$('#paisID' + idfila).focus();
			}else if(numEstado == '')
			{
					alert("Especificar Estado");
				$('#estadoID' + idfila).focus();
			}
			else if(numMunicipio == '')
			{
				alert("Especificar Municipio");
				$('#municipioID' + idfila).focus();
			}
			else if(numLocalidad == '')
			{
				alert("Especificar Localidad");
				$('#localidadID' + idfila).focus();
			}
		}



	}

function buscaColonia(controlid){
		var idfila= controlid.substr(18);
		
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "estadoID";
		camposLista[1] = 'municipioID';
		camposLista[2] = "asentamiento";		
		
		parametrosLista[0] = $('#estadoID'+idfila).val();
		parametrosLista[1] = $('#municipioID'+idfila).val();
		parametrosLista[2] = $('#coloniaDomicilioID'+idfila).val();
		
		lista(controlid, '2', '1', camposLista, parametrosLista,'listaColonias.htm');


}

function seleccionaOpcionMenuReg(){	
		$('tr[name=renglon]').each(function() {
			var numero= this.id.substr(7,this.id.length);
			var jsGradoEst 	 	 = eval("'sprofesion" + numero+ "'");	
			var jsCargo 		 = eval("'scargo" + numero+ "'");	
			var jsManifest 		 = eval("'smanifestCumplimiento" + numero+ "'");	
			var jsOrgano 		 = eval("'sorganoPerteneciente" + numero+ "'");	
			var jsPermanente 	 = eval("'spermanente" + numero+ "'");	
			var jsTipoMovimiento = eval("'stipoMovimiento" + numero+ "'");	


			var valorGradoEst= document.getElementById(jsGradoEst).value;	
			var valorCargo= document.getElementById(jsCargo).value;	
			var valorManifest= document.getElementById(jsManifest).value;	
			var valorOrgano= document.getElementById(jsOrgano).value;
			var valorPermanente= document.getElementById(jsPermanente).value;	
			var valorTipoMovimiento= document.getElementById(jsTipoMovimiento).value;	






			$('#profesion'+numero+' option[value='+ valorGradoEst +']').attr('selected','true');	
			$('#cargo'+numero+' option[value='+ valorCargo +']').attr('selected','true');	
			$('#manifestCumplimiento'+numero+' option[value='+ valorManifest +']').attr('selected','true');	
			$('#organoPerteneciente'+numero+' option[value='+ valorOrgano +']').attr('selected','true');	
			$('#permanente'+numero+' option[value='+ valorPermanente +']').attr('selected','true');
			$('#tipoMovimiento'+numero+' option[value='+ valorTipoMovimiento +']').attr('selected','true');	

			esTab = true;
			//consultaEntidad("entidad"+numero);
		});
		
	}

	function iniciarDatePikers(){	
		$('tr[name=renglon]').each(function() {
			var numero= this.id.substr(7,this.id.length);

			$("#fechaContra"+numero).datepicker({
    			showOn: "button",
    			buttonImage: "images/calendar.png",
    			buttonImageOnly: true,
				changeMonth: true, 
				changeYear: true,
				dateFormat: 'yymmdd',
				yearRange: '-100:+10'							
			});

			$("#fechaVencim"+numero).datepicker({
    			showOn: "button",
    			buttonImage: "images/calendar.png",
    			buttonImageOnly: true,
				changeMonth: true, 
				changeYear: true,
				dateFormat: 'yymmdd',
				yearRange: '-100:+10'							
			});
			
		});
		
	}


function cargarMenus(){

	// Combo Profesion
	opcionMenuRegBean = {
						'menuID' : catMenuRegulatorio.GradoEst,
						'descripcion': ''
						};
	opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.Combo,opcionMenuRegBean,function(opcionesMenuRegBean16) {
			 menuGradoEst = opcionesMenuRegBean16;
			});

	//Combo Cargo
	opcionMenuRegBean = {
						'menuID' : catMenuRegulatorio.Cargo,
						'descripcion': ''
						};

	opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.Combo,opcionMenuRegBean,function(opcionesMenuRegBean6) {
			menuCargo = opcionesMenuRegBean6;
			});

	//Combo Manifestación de Cumplimiento
	opcionMenuRegBean = {
						'menuID' : catMenuRegulatorio.Manifest,
						'descripcion': ''
						};

	opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.Combo,opcionMenuRegBean,function(opcionesMenuRegBean7) {
			menuManifest = opcionesMenuRegBean7;
			});

	//Combo Organo al que pertenece
	opcionMenuRegBean = {
						'menuID' : catMenuRegulatorio.Organo,
						'descripcion': ''
						};
	opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.Combo,opcionMenuRegBean,function(opcionesMenuRegBean8) {
			menuOrgano = opcionesMenuRegBean8;
			});
	//Combo Permanente o Suplente
	opcionMenuRegBean = {
						'menuID' : catMenuRegulatorio.Permanente,
						'descripcion': ''
						};
	opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.Combo,opcionMenuRegBean,function(opcionesMenuRegBean9) {
			menuPermanente = opcionesMenuRegBean9;
			});
	//Combo Tipo de Movimiento
	opcionMenuRegBean = {
						'menuID' : catMenuRegulatorio.TipoMovimiento,
						'descripcion': ''
						};
	opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.Combo,opcionMenuRegBean,function(opcionesMenuRegBean17) {
			menuTipoMovimiento = opcionesMenuRegBean17;
			});

}


function cargarCombos(id){
	$('#profesion'+id).each(function() {  $('#profesion'+id+' option').remove(); });
	$('#cargo'+id).each(function() {  $('#cargo'+id+' option').remove(); });
	$('#manifestCumplimiento'+id).each(function() {  $('#manifestCumplimiento'+id+' option').remove(); });
	$('#organoPerteneciente'+id).each(function() { $('#organoPerteneciente'+id+' option').remove(); });
	$('#permanente'+id).each(function() { $('#permanente'+id+' option').remove(); });
	$('#tipoMovimiento'+id).each(function() { $('#tipoMovimiento'+id+' option').remove(); });
	// se agrega la opcion por default
	$('#profesion'+id).append( new Option('SELECCIONAR', '', true, true));
	$('#cargo'+id).append( new Option('SELECCIONAR', '', true, true));
	$('#manifestCumplimiento'+id).append( new Option('SELECCIONAR', '', true, true));
	$('#organoPerteneciente'+id).append( new Option('SELECCIONAR', '', true, true));
	$('#permanente'+id).append( new Option('SELECCIONAR', '', true, true));
	$('#tipoMovimiento'+id).append( new Option('SELECCIONAR', '', true, true));
		
	for ( var j = enteroCero; j < menuGradoEst.length; j++) {										
		$('#profesion'+id).append(new Option(menuGradoEst[j].descripcion,menuGradoEst[j].codigoOpcion,true,true));
		}

	for ( var j = enteroCero; j < menuCargo.length; j++) {										
		$('#cargo'+id).append(new Option(menuCargo[j].descripcion,menuCargo[j].codigoOpcion,true,true));
		}

	for ( var j = enteroCero; j < menuManifest.length; j++) {										
		$('#manifestCumplimiento'+id).append(new Option(menuManifest[j].descripcion,menuManifest[j].codigoOpcion,true,true));
		}

	for ( var j = enteroCero; j < menuOrgano.length; j++) {										
		$('#organoPerteneciente'+id).append(new Option(menuOrgano[j].descripcion,menuOrgano[j].codigoOpcion,true,true));
		}
	
	for ( var j = enteroCero; j < menuPermanente.length; j++) {										
		$('#permanente'+id).append(new Option(menuPermanente[j].descripcion,menuPermanente[j].codigoOpcion,true,true));
		}
	
	for ( var j = enteroCero; j < menuTipoMovimiento.length; j++) {										
		$('#tipoMovimiento'+id).append(new Option(menuTipoMovimiento[j].descripcion,menuTipoMovimiento[j].codigoOpcion,true,true));
		}
	
	$('#profesion'+id).val('').selected = true;
	$('#cargo'+id).val('').selected = true;
	$('#manifestCumplimiento'+id).val('').selected = true;
	$('#organoPerteneciente'+id).val('').selected = true;
	$('#permanente'+id).val('').selected = true;
	$('#tipoMovimiento'+id).val('').selected = true;
						
}





function agregarRegistro(){	
	var numeroFila=consultaFilas();
	
	var nuevaFila = parseInt(numeroFila) + 1;					
	var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
	 	 	  
		if(numeroFila == 0){
			tds += '<td><input  id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="6"  value="1" autocomplete="off"  type="hidden" />';
			tds += '<input type="hidden" id="stipoMovimiento'+nuevaFila+'" maxlength="7"  name="stipoMovimiento"  size="10" value=""/><select name="lTipoMovimiento" id="tipoMovimiento'+nuevaFila+'" >	</select></td>';
			tds += '<td><input type="text" id="nombreFuncionario'+nuevaFila+'" maxlength="100" name="lNombreFuncionario" onkeyup="return soloAlfanumericos(this.id);" onblur="ponerMayusculas(this);" size="30" value=""/></td>';
			tds += '<td><input type="text" id="rfc'+nuevaFila+'" maxlength="13" name="lRFC" onkeyup="return soloAlfanumericos(this.id);" onblur="ponerMayusculas(this);" size="15" value=""/></td>';
			tds += '<td><input type="text" id="curp'+nuevaFila+'" maxlength="18" name="lCURP" onkeyup="return soloAlfanumericos(this.id);" onblur="ponerMayusculas(this);" size="21" value=""/></td>';
			tds += '<td><input type="hidden" id="sprofesion'+nuevaFila+'"name="sprofesion" size="20" value=""/><select name="lProfesion" id="profesion'+nuevaFila+'" ></select></td>';
			tds += '<td><input type="text" id="calleDomicilio'+nuevaFila+'"  onkeyup="return soloAlfanumericos(this.id);" onblur="ponerMayusculas(this);" maxlength="150" name="lCalleDomicilio"  size="30" value=""/></td>';	
			tds += '<td><input type="text" id="numeroExt'+nuevaFila+'" onkeyup="return soloAlfanumericos(this.id);"  maxlength="10" name="lNumeroExt" size="10" value=""</td>';
			tds += '<td><input type="text" id="numeroInt'+nuevaFila+'"  onkeyup="return soloAlfanumericos(this.id);"  maxlength="10" name="lNumeroInt" size="10" value=""/></td>';
			tds += '<td nowrap="nowrap"><input type="text" id="paisID'+nuevaFila+'"  name="lPais" size="8"  onkeyup="buscaPais(this.id)" onblur="consultaPais(this.id)" value="" class="display: inline-block" />	';
			tds += '<input type="text" id="despaisID'+nuevaFila+'" readonly="" disabled="" name="despaisID" size="30" value="" class="display: inline-block" /></td>	';
			tds += '<td nowrap="nowrap"><input type="text" id="estadoID'+nuevaFila+'"  name="lEstado" size="8" onkeyup="buscaEstado(this.id)" onblur="consultaEstado(this.id)" value="" class="display: inline-block" /> ';
			tds += '<input type="text" id="desestadoID'+nuevaFila+'" readonly="" disabled="" name="desestadoID" size="30" value="" class="display: inline-block" /></td>';
			tds += '<td nowrap="nowrap"><input type="text "id="municipioID'+nuevaFila+'" name="lMunicipio" size="12" onkeyup="buscaMunicipio(this.id)" onblur="consultaMunicipio(this.id)" value="" class="display: inline-block"  />	';
			tds += '<input type="text" id="desmunicipioID'+nuevaFila+'" readonly="" disabled="" name="desmunicipioID" size="30" value="" class="display: inline-block" /></td>';
			tds += '<td nowrap="nowrap"><input type="text" id="localidadID'+nuevaFila+'"  name="lLocalidad" size="12" onkeyup="buscaLocalidad(this.id)"	onblur="consultaLocalidad(this.id)" value="" class="display: inline-block" />';	
			tds += '<input type="text" id="deslocalidadID'+nuevaFila+'" readonly="" disabled="" name="deslocalidadID" size="30" value="" class="display: inline-block" /></td>';
			tds += '<td nowrap="nowrap"><input type="text" id="coloniaDomicilioID'+nuevaFila+'" maxlength="10" name="lColoniaDomicilio" onkeyup="buscaColonia(this.id)" onblur="consultaColonia(this.id);" size="12" value="" class="display: inline-block"/>';
			tds += '<input type="text" id="descoloniaDomicilioID'+nuevaFila+'" readonly="" disabled=""  onkeyPress="return validaSoloNumeros(event);" name="descoloniaDomicilioID" size="30" value="" class="display: inline-block" /></td>';
			tds += '<td><input type="text" id="codigoPostal'+nuevaFila+'" maxlength="5" name="lCodigoPostal"  onkeyPress="return validaSoloNumeros(event);" onblur="ponerMayusculas(this);" size="10" value="" /></td>';				
			tds += '<td><input type="text" id="telefono'+nuevaFila+'" maxlength="20" name="lTelefono" onkeyPress="return validaSoloNumeros(event);"  size="10" value=""/></td>';
			tds += '<td><input type="text" id="email'+nuevaFila+'" maxlength="75" name="lEmail" onblur="validaEmail(this.id);" size="30" value=""/></td>';
			tds += '<td nowrap="nowrap"><input type="text" id="fechaM'+nuevaFila+'" esCalendario="true" maxlength="10" name="lFechaMovimiento" onblur="esFechaValida(this.value,this.id)" size="12" value=""/></td>';
			tds += '<td nowrap="nowrap"><input type="text" id="fechaI'+nuevaFila+'"" esCalendario="true" maxlength="10" onblur="esFechaValida(this.value,this.id)" name="lFechaInicio" size="12" value=""/></td>';
			tds += '<td><input type="hidden" id="sorganoPerteneciente'+nuevaFila+'"  name="sorganoPerteneciente" size="20" value=""/> <select name="lOrganoPerteneciente" id="organoPerteneciente'+nuevaFila+'" ></select></td>';
			tds += '<td><input type="hidden" id="scargo'+nuevaFila+'"  name="scargo" size="20" value=""/><select name="lCargo" id="cargo'+nuevaFila+'" ></select></td>';
			tds += '<td><input type="hidden" id="spermanente'+nuevaFila+'"  name="spermanente" size="20" value=""/><select name="lPermanente" id="permanente'+nuevaFila+'"></select></td>';
			tds += '<td><input type="hidden" id="smanifestCumplimiento'+nuevaFila+'"  name="smanifestCumplimiento" size="20" value=""/>	<select name="lManifestCumplimiento" id="manifestCumplimiento'+nuevaFila+'" ></select></td>';
			
		} else{    		
			var valor = numeroFila+ 1;
			tds += '<td><input  id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="6"  value="'+valor+'"  autocomplete="off"  type="hidden" />';
			tds += '<input type="hidden" id="stipoMovimiento'+nuevaFila+'" maxlength="7"  name="stipoMovimiento"  size="10" value=""/><select name="lTipoMovimiento" id="tipoMovimiento'+nuevaFila+'" >	</select></td>';
			tds += '<td><input type="text" id="nombreFuncionario'+nuevaFila+'" maxlength="100" name="lNombreFuncionario" onkeyup="return soloAlfanumericos(this.id);"  onblur="ponerMayusculas(this);" size="30" value=""/></td>';
			tds += '<td><input type="text" id="rfc'+nuevaFila+'" maxlength="13" name="lRFC"  onkeyup="return soloAlfanumericos(this.id);" onblur="ponerMayusculas(this);" size="15" value=""/></td>';
			tds += '<td><input type="text" id="curp'+nuevaFila+'" maxlength="18" name="lCURP"  onkeyup="return soloAlfanumericos(this.id);" onblur="ponerMayusculas(this);" size="21" value=""/></td>';
			tds += '<td><input type="hidden" id="sprofesion'+nuevaFila+'"name="sprofesion" size="20" value=""/><select name="lProfesion" id="profesion'+nuevaFila+'" ></select></td>';
			tds += '<td><input type="text" id="calleDomicilio'+nuevaFila+'"   onkeyup="return soloAlfanumericos(this.id);" onblur="ponerMayusculas(this);" maxlength="150" name="lCalleDomicilio"  size="30" value=""/></td>';	
			tds += '<td><input type="text" id="numeroExt'+nuevaFila+'" onkeyup="return soloAlfanumericos(this.id);"   maxlength="10" name="lNumeroExt"  size="10" value=""</td>';
			tds += '<td><input type="text" id="numeroInt'+nuevaFila+'" onkeyup="return soloAlfanumericos(this.id);" maxlength="10"   name="lNumeroInt" size="10" value=""/></td>';
			tds += '<td nowrap="nowrap"><input type="text" id="paisID'+nuevaFila+'"  name="lPais" size="8"  onkeyup="buscaPais(this.id)" onblur="consultaPais(this.id)" value="" class="display: inline-block" />	';
			tds += '<input type="text" id="despaisID'+nuevaFila+'" readonly="" disabled="" name="despaisID" size="30" value="" class="display: inline-block" /></td>	';
			tds += '<td nowrap="nowrap"><input type="text" id="estadoID'+nuevaFila+'"  name="lEstado" size="8" onkeyup="buscaEstado(this.id)" onblur="consultaEstado(this.id)" value="" class="display: inline-block" /> ';
			tds += '<input type="text" id="desestadoID'+nuevaFila+'" readonly="" disabled="" name="desestadoID" size="30" value="" class="display: inline-block" /></td>';
			tds += '<td nowrap="nowrap"><input type="text "id="municipioID'+nuevaFila+'" name="lMunicipio" size="12" onkeyup="buscaMunicipio(this.id)" onblur="consultaMunicipio(this.id)" value="" class="display: inline-block"  />	';
			tds += '<input type="text" id="desmunicipioID'+nuevaFila+'" readonly="" disabled="" name="desmunicipioID" size="30" value="" class="display: inline-block" /></td>';
			tds += '<td nowrap="nowrap"><input type="text" id="localidadID'+nuevaFila+'"  name="lLocalidad" size="12" onkeyup="buscaLocalidad(this.id)"	onblur="consultaLocalidad(this.id)" value="" class="display: inline-block" />';	
			tds += '<input type="text" id="deslocalidadID'+nuevaFila+'" readonly="" disabled="" name="deslocalidadID" size="30" value="" class="display: inline-block" /></td>';
			tds += '<td nowrap="nowrap"><input type="text" id="coloniaDomicilioID'+nuevaFila+'" maxlength="10" name="lColoniaDomicilio" onkeyup="buscaColonia(this.id)" onblur="consultaColonia(this.id);" size="12" value="" class="display: inline-block"/>';
			tds += '<input type="text" id="descoloniaDomicilioID'+nuevaFila+'" readonly="" disabled="" name="descoloniaDomicilioID" size="30" value="" class="display: inline-block" /></td>';
			tds += '<td><input type="text" id="codigoPostal'+nuevaFila+'" maxlength="5" name="lCodigoPostal" onkeyPress="return validaSoloNumeros(event);" onblur="ponerMayusculas(this);" size="10" value="" /></td>';				
			tds += '<td><input type="text" id="telefono'+nuevaFila+'" maxlength="20" name="lTelefono" onkeyPress="return validaSoloNumeros(event);"  size="10" value=""/></td>';
			tds += '<td><input type="text" id="email'+nuevaFila+'" maxlength="75" name="lEmail" onblur="validaEmail(this.id);" size="30" value=""/></td>';
			tds += '<td nowrap="nowrap"><input type="text" id="fechaM'+nuevaFila+'" esCalendario="true" maxlength="10" name="lFechaMovimiento" onblur="esFechaValida(this.value,this.id)" size="12" value=""/></td>';
			tds += '<td nowrap="nowrap"><input type="text" id="fechaI'+nuevaFila+'"" esCalendario="true" maxlength="10" onblur="esFechaValida(this.value,this.id)" name="lFechaInicio" size="12" value=""/></td>';
			tds += '<td><input type="hidden" id="sorganoPerteneciente'+nuevaFila+'"  name="sorganoPerteneciente" size="20" value=""/> <select name="lOrganoPerteneciente" id="organoPerteneciente'+nuevaFila+'" ></select></td>';
			tds += '<td><input type="hidden" id="scargo'+nuevaFila+'"  name="scargo" size="20" value=""/><select name="lCargo" id="cargo'+nuevaFila+'" ></select></td>';
			tds += '<td><input type="hidden" id="spermanente'+nuevaFila+'"  name="spermanente" size="20" value=""/><select name="lPermanente" id="permanente'+nuevaFila+'"></select></td>';
			tds += '<td><input type="hidden" id="smanifestCumplimiento'+nuevaFila+'"  name="smanifestCumplimiento" size="20" value=""/>	<select name="lManifestCumplimiento" id="manifestCumplimiento'+nuevaFila+'" ></select></td>';
			
		}
		tds += '<td><input type="button" name="eliminar" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminarRegistro(this.id)"/>';
		tds += '<input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregarRegistro()"/></td>';
		tds += '</tr>';	   	   
		
		$("#miTabla").append(tds);
		cargarCombos(nuevaFila);
		iniciarDatePikers();
		
		// Asignamos el foco al campo entidad
		$('#entidad'+nuevaFila).focus();
		
		habilitaBoton('grabar');
		deshabilitaBoton('generar');
		
		agregaFormatoControles('formaGenerica');
		

		return false;		
	}


function validarRegistro(){		
    var respuesta = true;
	$('tr[name=renglon]').each(function() {		
		numero= this.id.substr(7,this.id.length);		
		var idCampo = 'tipoMovimiento';
		var mensaje = "Seleccione el Tipo de Movimiento";
		
		if(validaCampo(idCampo, numero, mensaje)==false){
			
			respuesta = false;
			return false;
			
		}
		
		var idCampo = 'nombreFuncionario';
		var mensaje = "El Nombre del Funcionario está vacío";
		
		if(validaCampo(idCampo, numero, mensaje)==false){
			
			respuesta = false;
			return false;
			
		}

		var idCampo = 'rfc';
		var mensaje = "El RFC está vacío";

		if(validaCampo(idCampo, numero, mensaje)==false){
			respuesta = false;
			return false;
		}


		var idCampo = 'curp';
		var mensaje = "La CURP está vacía";

		if(validaCampo(idCampo, numero, mensaje)==false){
			respuesta = false;
			return false;
		}


		var idCampo = 'profesion';
		var mensaje = "Seleccione el Título o Profesión";

		if(validaCampo(idCampo, numero, mensaje)==false){
			respuesta = false;
			return false;
		}

		var idCampo = 'calleDomicilio';
		var mensaje = "La Calle está vacía";

		if(validaCampo(idCampo, numero, mensaje)==false){
			respuesta = false;
			return false;
		}


		var idCampo = 'numeroExt';
		var mensaje = "El Número Exterior está vacío";

		if(validaCampo(idCampo, numero, mensaje)==false){
			respuesta = false;
			return false;
		}


		var idCampo = 'numeroInt';
		var mensaje = "El Número Interior está vacío";

		if(validaCampo(idCampo, numero, mensaje)==false){
			respuesta = false;
			return false;
		}


		var idCampo = 'numeroInt';
		var mensaje = "El Número Interior está vacío";

		if(validaCampo(idCampo, numero, mensaje)==false){
			respuesta = false;
			return false;
		}


		var idCampo = 'paisID';
		var idDescripcion = 'despaisID';
		var mensaje = "El País está vacío";

		if(validaCampo(idCampo, numero, mensaje)==false){
			respuesta = false;
			return false;
		}

		mensaje = "Ingrese el País";

		if(validaLista(idCampo, numero, mensaje, idDescripcion)==false){
			respuesta = false;
			return false;
		}

		var idCampo = 'estadoID';
		var idDescripcion = 'desestadoID';
		var mensaje = "El Estado está vacío";

		if(validaCampo(idCampo, numero, mensaje)==false){
			respuesta = false;
			return false;
		}

		mensaje = "Ingrese el Estado";

		if(validaLista(idCampo, numero, mensaje, idDescripcion)==false){
			respuesta = false;
			return false;
		}


		var idCampo = 'municipioID';
		var idDescripcion = 'desmunicipioID';
		var mensaje = "El Municipio está vacío";

		if(validaCampo(idCampo, numero, mensaje)==false){
			respuesta = false;
			return false;
		}

		mensaje = "Ingrese el Municipio";

		if(validaLista(idCampo, numero, mensaje, idDescripcion)==false){
			respuesta = false;
			return false;
		}

		var idCampo = 'desmunicipioID';
		var mensaje = "El Municipio está vacío";

		if(validaCampo(idCampo, numero, mensaje)==false){
			respuesta = false;
			return false;
		}


		var idCampo = 'localidadID';
		var idDescripcion = 'deslocalidadID';
		var mensaje = "La Localidad está vacía";

		if(validaCampo(idCampo, numero, mensaje)==false){
			respuesta = false;
			return false;
		}

		mensaje = "Ingrese la Localidad";

		if(validaLista(idCampo, numero, mensaje, idDescripcion)==false){
			respuesta = false;
			return false;
		}


		var idCampo = 'deslocalidadID';
		var mensaje = "La Localidad está vacía";

		if(validaCampo(idCampo, numero, mensaje)==false){
			respuesta = false;
			return false;
		}


		var idCampo = 'coloniaDomicilioID';
		var idDescripcion = 'descoloniaDomicilioID';
		var mensaje = "La Colonia está vacía";

		if(validaCampo(idCampo, numero, mensaje)==false){
			respuesta = false;
			return false;
		}

		mensaje = "Ingrese la Colonia";

		if(validaLista(idCampo, numero, mensaje, idDescripcion)==false){
			respuesta = false;
			return false;
		}


		var idCampo = 'descoloniaDomicilioID';
		var mensaje = "La Colonia está vacía";

		if(validaCampo(idCampo, numero, mensaje)==false){
			respuesta = false;
			return false;
		}


		var idCampo = 'codigoPostal';
		var mensaje = "El Código Postal está vacío";

		if(validaCampo(idCampo, numero, mensaje)==false){
			respuesta = false;
			return false;
		}


		var idCampo = 'telefono';
		var mensaje = "El Teléfono está vacío";

		if(validaCampo(idCampo, numero, mensaje)==false){
			respuesta = false;
			return false;
		}


		var idCampo = 'email';
		var mensaje = "El Correo Electrónico está vacío";

		if(validaCampo(idCampo, numero, mensaje)==false){
			respuesta = false;
			return false;
		}


		var idCampo = 'fechaM';
		var mensaje = "La Fecha del Movimiento está vacía";

		if(validaCampo(idCampo, numero, mensaje)==false){
			respuesta = false;
			return false;
		}


		var idCampo = 'fechaI';
		var mensaje = "La Fecha de Inicio o Conclusión de Gestión esta vacía";

		if(validaCampo(idCampo, numero, mensaje)==false){
			respuesta = false;
			return false;
		}


		var idCampo = 'organoPerteneciente';
		var mensaje = "Seleccione el Órgano al que pertenece";

		if(validaCampo(idCampo, numero, mensaje)==false){
			respuesta = false;
			return false;
		}


		var idCampo = 'cargo';
		var mensaje = "Seleccione un Cargo";

		if(validaCampo(idCampo, numero, mensaje)==false){
			respuesta = false;
			return false;
		}


		var idCampo = 'permanente';
		var mensaje = "Seleccione si es Permanenente o Suplente";

		if(validaCampo(idCampo, numero, mensaje)==false){
			respuesta = false;
			return false;
		}


		var idCampo = 'manifestCumplimiento';
		var mensaje = "Seleccione la Manifestación de Cumplimiento";

		if(validaCampo(idCampo, numero, mensaje)==false){
			respuesta = false;
			return false;
		}

		
	});
	return respuesta;	
}


function validaCampo(idCampo, fila, mensaje)
{
	if($("#"+idCampo+fila).val()=='')
		{
		   alert(mensaje);	
		   $("#"+idCampo+fila).focus();
		   return false;
		
		}
	else
		{
			return true;
		}	
}


function validaLista(idCampo, fila, mensaje, idDescripcion)
{
	if(isNaN($("#"+idCampo+fila).val()))
		{
		   alert(mensaje);
		   $("#"+idCampo+fila).val("");	
		   $("#"+idDescripcion+fila).val("");
		   $("#"+idCampo+fila).focus();
		   return false;
		
		}
	else
		{
			return true;
		}		
	
}

//consulta cuantas filas tiene el grid de documentos
function consultaFilas(){
	var totales=enteroCero;
	$('tr[name=renglon]').each(function() {
		totales++;		
	});
	return totales;
}

function validaEmail(mail){
	var jqNumero = eval("'#" + mail + "'");
	var valr= $(jqNumero).val();	
	   
   if( /[a-zA-Z0-9ñÑ._%+-]+@[a-zA-Z0-9Ññ.-]+\.[a-zA-ZñÑ]{2,3}$/.test( $(jqNumero).val() ) ) {
   
  	  $(jqNumero).val(valr); 
       return true;
    }
      alert("Formato de Correo Electrónico no Válido");
      $(jqNumero).focus();
}

function soloAlfanumericos(par_cadena) {
	
   
    var jqNumero = eval("'#" + par_cadena + "'");
	var valr= $(jqNumero).val();	
	
	 if( /[^a-zA-Z0-9ñÑ\s]/.test( $(jqNumero).val() ) ) {
         alert('No se permiten caracteres especiales');
      
  	    var s= valr.substr(0,valr.length-1);
  	    $(jqNumero).val(s);
       return false;
    }
    return true;
}
function eliminarRegistro(control){	
	var contador = enteroCero ;
	var numeroID = control;
	
	var jqRenglon 		= eval("'#renglon" + numeroID + "'");
	var jqNumero 		= eval("'#consecutivoID" + numeroID + "'");
	var jqAgrega 		= eval("'#agrega" + numeroID + "'");
	var jqElimina 		= eval("'#" + numeroID + "'");

	// se elimina la fila seleccionada
	$(jqNumero).remove();
	$(jqElimina).remove();
	$(jqAgrega).remove();
	$(jqRenglon).remove();
	
	//Reordenamiento de Controles
	contador = 1;
	var numero= enteroCero;
	$('tr[name=renglon]').each(function() {		
		numero= this.id.substr(7,this.id.length);
		var jqRenglon1 		= eval("'#renglon"+numero+"'");
		var jqNumero1 		= eval("'#consecutivoID"+numero+"'");
		var jqAgrega1 		=eval("'#agrega"+ numero+"'");
		var jqElimina1 		= eval("'#"+numero+ "'");
	
		$(jqNumero1).attr('id','consecutivoID'+contador);
		$(jqAgrega1).attr('id','agrega'+contador);
		$(jqElimina1).attr('id',contador);
		$(jqRenglon1).attr('id','renglon'+ contador);
		contador = parseInt(contador + 1);	
		
	});

	deshabilitaBoton('generar');
	
}


function Validador(e) {
	key=(document.all) ? e.keyCode : e.which;
	if (key < 48 || key > 57 || key == 46) {

		if (key==8|| key == 46)	{ 
			return true;
		}
		else
			alert("sólo números");
		return false;
	}
}


$('#fecha').blur(function() {
		consultaRegistroRegulatorioA1713();
		  
	});
$('#fecha').change(function (){
	   var fechaActual = parametroBean.fechaAplicacion;	
	   var fechaSeleccionado = $('#fecha').val();
	   
	   if(this.value > fechaActual){
		   alert("La fecha Indicada es Mayor a la Fecha Actual del Sistema.");
		   
		   consultaRegistroRegulatorioA1713();
		   this.focus();
	   }else{
		   consultaRegistroRegulatorioA1713();
	   }
});

function consultaRegistroRegulatorioA1713(){	
	var fecha 	= $('#fecha').val();
	
	var params 	= {};
	params['tipoLista'] = 1;
	params['fecha'] 		= fecha;

	
	$.post("regulatorioA1713GridVista.htm", params, function(data){
		if(data.length >enteroCero) {
			$('#divRegulatorioA1713').html(data);
		
			$('#divRegulatorioA1713').show();
			
			if(consultaFilas() > enteroCero){
				habilitaBoton('grabar');
				habilitaBoton('generar');
			}else{
				deshabilitaBoton('grabar');
				deshabilitaBoton('generar');
			}

			iniciarDatePikers();

			// Intervalo que valida los objetos que contienen las opciones para los combos
			var cargando = setInterval(function(){
				if(menuGradoEst.length > enteroCero & menuCargo.length > enteroCero 
				    & menuManifest.length > enteroCero & menuOrgano.length > enteroCero
				    & menuPermanente.length > enteroCero & menuTipoMovimiento.length > enteroCero	){

						for (var i = 1; i <= consultaFilas(); i++) {
							consultaPais("paisID"+i);
							consultaEstado("estadoID"+i);
							consultaMunicipio("municipioID"+i);
							consultaLocalidad("localidadID"+i);
							consultaColonia("coloniaDomicilioID"+i);
							cargarCombos(i);
							

							seleccionaOpcionMenuReg();
						}
					
				 clearInterval(cargando);

				}

			},100);
	
			agregaFormatoControles('formaGenerica');			
			
			$('#generar').click(function(){

					  	 		if($('#excel').is(':checked')){
									if(consultaFilas()>enteroCero ){
										generaReporte(catRegulatorioA1713.Excel);
									}
								}
								if($('#csv').is(':checked')){
									if(consultaFilas()>enteroCero){
										generaReporte(catRegulatorioA1713.Csv);
									}
								}		

				});

		}else{				
			$('#divRegulatorioA1713').html("");
			$('#fieldsetDiasPasoVencido').hide();
			$('#divRegulatorioA1713').hide(); 
		}
	});


}


function validarPorcentaje(controlID, valor){
	var numero= controlID.substr(10,controlID.length);

	if(isNaN(parseFloat(valor))){
		$("#"+controlID).focus();
		$("#"+controlID).val('0.00');
	}else{
		if(valor.length > 6){
			alert("Máximo 3 dígitos y 2 decimales");
			$("#"+controlID).focus();
			$("#"+controlID).val('0.00');
		}		
	}
}

function generaReporte(tipoReporte){
		   var fecha = $('#fecha').val();
		   
		   var url='';

		   url = 'reporteRegulatorioA1713.htm?tipoReporte=' + tipoReporte + '&fecha='+fecha + '&tipoEntidad='+tipoInstitucion;
		   window.open(url);
		   
	   };


function validaSoloNumeros(e) {
	key=(document.all) ? e.keyCode : e.which;
	if (key < 48 || key > 57 || key == 46) {

		if (key==8|| key == 46)	{ 
			return true;
		}
		else
			alert("sólo números");
		return false;
	}
}


// --------------- funcion para validar la fecha --------------------------
function esFechaValida(fecha,idfecha) {
	$('#'+idfecha).change(function (){
		   var fechaActual = parametroBean.fechaAplicacion;	
		   var fechaSeleccionado = $('#fecha').val();
		   $('#'+idfecha).focus();
		  
	});

	if (fecha != undefined && fecha != "") {
		
		var mes = fecha.substring(5, 7) * 1;
		var dia = fecha.substring(8, 10) * 1;
		var anio = fecha.substring(0, 4) * 1;
		

		switch (mes) {
		case 1:
		case 3:
		case 5:
		case 7:
		case 8:
		case 10:
		case 12:
			numDias = 31;
			break;
		case 4:
		case 6:
		case 9:
		case 11:
			numDias = 30;
			break;
		case 2:
			if (comprobarSiBisisesto(anio)) {
				numDias = 29;
			} else {
				numDias = 28;
			}
			;
			break;
		default:
			alert("Fecha Introducida es Errónea.");
			$('#'+idfecha).val('');
			$('#'+idfecha).focus();
		return false;
		}
		if (dia > numDias || dia == 0) {
			alert("Fecha Introducida es Errónea.");
			$('#'+idfecha).val('');
			$('#'+idfecha).focus();
			return false;
		}
		return true;
	}
}



function comprobarSiBisisesto(anio){
	if ((anio % 100 != enteroCero) && ((anio % 4 == enteroCero) || (anio % 400 == enteroCero))) {
		return true;
	} else {
		return false;
	}
}
