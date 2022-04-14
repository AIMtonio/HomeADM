var numReglon = "";
var descripcionID = "";
var clave = "";

var listaTiposClavesPresup = [];

var listaClavesPresupBaja = [];
var listaClavesPresupMod = [];

var catTipoTransaccionClavePresup = {
	'agrega' : '1',
	'agregaClasifClave' : '2',
	'modificaClasifClave' : '3'
};


$(document).ready(function(){
	esTab = true;

	deshabilitaBoton('grabaClsif', 'submit');
	deshabilitaBoton('modificaClasif', 'submit');
	deshabilitaControl('estatus');
	consultarTiposClavePresup();
	consultaGridClavePresup();
	consultaGridClasifClavePresup();

	consulClavesPresupuestalesCombo();
	agregaFormatoControles('formaGenerica');
	$("#nomClasifClavPresup").focus();
	$("#agregaClavePresup").focus();

	$.validator.setDefaults({submitHandler : function(event) {
		grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','numero','exitoTransParametro','falloTransParametro');
		}
	});

	/***********MANEJO DE EVENTOS******************/
	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab = true;
		}
	});


	$('#grabaClsif').click(function() {

		if($('#descripClasifClave').val() == "" || $('#descripClasifClave').val() == null ){
			mensajeSis("Especifique la Descripción de Clasificación Clave Presupuestal.");
			$("#descripClasifClave").focus();
			return false;
		}

		if($('#prioridad').val() == "" || $('#prioridad').val() == null ){
			mensajeSis("Especifique la Prioridad de Clasificación Clave Presupuestal.");
			$("#prioridad").focus();
			return false;
		}

		if($('#nomClavesPresupID').val() == "" || $('#nomClavesPresupID').val() == null){
			mensajeSis("Especifique los Claves Presupuestales.");
			$("#nomClavesPresupID").focus();
			return false;
		}

		$('#tipoTransaccion').val(catTipoTransaccionClavePresup.agregaClasifClave);
	});

	$('#modificaClasif').click(function() {
		if($('#nomClasifClavPresup').val() == "" || $('#nomClasifClavPresup').val() == null ){
			mensajeSis("Especifique la Clasificación Clave Presupuestal a Modificar.");
			$("#nomClasifClavPresup").focus();
			return false;
		}

		if($('#descripClasifClave').val() == "" || $('#descripClasifClave').val() == null ){
			mensajeSis("Especifique la Descripción de Clasificación Clave Presupuestal.");
			$("#descripClasifClave").focus();
			return false;
		}

		if($('#prioridad').val() == "" || $('#prioridad').val() == null ){
			mensajeSis("Especifique la Prioridad de Clasificación Clave Presupuestal.");
			$("#prioridad").focus();
			return false;
		}

		if($('#nomClavesPresupID').val() == "" || $('#nomClavesPresupID').val() == null){
			mensajeSis("Especifique los Claves Presupuestales.");
			$("#nomClavesPresupID").focus();
			return false;
		}

		$('#tipoTransaccion').val(catTipoTransaccionClavePresup.modificaClasifClave);
	});


	$('#nomClasifClavPresup').bind('keyup',function(e){
		lista('nomClasifClavPresup', '2', '1', 'descripcion', $('#nomClasifClavPresup').val(), 'clasifClavePresupListaVista.htm');
	});

	$('#nomClasifClavPresup').blur(function(){
		setTimeout("$('#cajaLista').hide();", 200);
		var nomClasifClavPresupID = $('#nomClasifClavPresup').val();
		if(esTab){
			if(nomClasifClavPresupID == 0 && nomClasifClavPresupID != '' && nomClasifClavPresupID != null){
				$('#descripClasifClave').val("");
				$('#estatus').val("A");
				deshabilitaControl('estatus');
				$("#nomClavesPresupID option").removeAttr("selected");
				$('#prioridad').val("");
				habilitaBoton('grabaClsif', 'submit');
				deshabilitaBoton('modificaClasif', 'submit');
			} else if(nomClasifClavPresupID > 0 && nomClasifClavPresupID != '' && nomClasifClavPresupID != null){
				$('#descripClasifClave').val("");
				$('#estatus').val("");
				$("#nomClavesPresupID option").removeAttr("selected");
				$('#prioridad').val("");
				consultaClasifClavePresup(this.id);
			}else if(nomClasifClavPresupID != ''){
				mensajeSis("Espeficique una Clasificacion Clave Presupuestal Valido");
			}
		}
	});

	$('#nomClavesPresupID').change(function() {
		var todos="0";
		var opcionSelec = $('#nomClavesPresupID').val();
		if(opcionSelec == todos){
			seleccionaTodosClavesPresup();
		}
	});

	$('#formaGenerica').validate({
		rules : {
		},

		messages : {
		}
	});
});

function exitoTransParametro(){
	if($('#tipoTransaccion').val() == catTipoTransaccionClavePresup.agregaClasifClave || $('#tipoTransaccion').val() == catTipoTransaccionClavePresup.modificaClasifClave){
		consultaGridClasifClavePresup();
		consulClavesPresupuestalesCombo();
		consultarTiposClavePresup();
		consultaGridClavePresup();
		$('#descripClasifClave').val("");
		$('#nomClasifClavPresup').val("");
		$('#estatus').val("");
		$('#prioridad').val("");
		$("#nomClavesPresupID option").removeAttr("selected");
		deshabilitaBoton('grabaClsif', 'submit');
		deshabilitaBoton('modificaClasif', 'submit');
	}
	else {
		consultarTiposClavePresup();
		consultaGridClavePresup();
		consultaGridClasifClavePresup();
		consulClavesPresupuestalesCombo();
	}

	listaClavesPresupBaja = [];
	$('#clavesPresupBaj').val('');
	listaClavesPresupMod = [];
	$('#clavesPresupMod').val('');
}

function falloTransParametro(){

}

/* ======================= FUNCION PARA AGREGAR NUEVO REGLON ======================= */
function agregaClavePresupuestal(){
	habilitaBoton('graba', 'submit');
	var numeroFila = $("#numero").asNumber();
	var nuevaFila = numeroFila + 1;
	var tds = '<tr id="renglonClave' + nuevaFila + '" name="renglonClave" style="display: table-row;">';
		tds += '<td> <input  type="hidden" id="nomClavePresupID'+nuevaFila+'" name="nomClavePresupID" size="6" value="0"/>';
		tds += '<input  type="hidden" id="nomClasifClavPresupID'+nuevaFila+'" name="nomClasifClavPresupID" size="6" value="0"/>';
		tds += '<input type="text" id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="6" value="' + nuevaFila + '" readOnly="true"/> </td>';
		tds += '<td ><select id="tipoClavePresupID'+nuevaFila+'" name="tipoClavePresupID" onBlur="consultaTipoClavePresup(this.id)" onChange="registraClavePresupModificada(this.id.substring(17))"><option value="">SELECCIONE</option></select> </td>';
		tds += '<td><input type="hidden" id="reqClave'+nuevaFila+'" name="reqClave" size="10" value=""/>'
		tds += '<input type="text" id="clave'+nuevaFila+'" name="clave" size="10" value="" onBlur="ponerMayusculas(this);  validaClave(this.id)" onChange="registraClavePresupModificada(this.id.substring(5))"/></td>';
		tds += '<td> <input type="text" id="descripcion'+nuevaFila+'" name="descripcion" size="50" value="" onBlur="ponerMayusculas(this)" onChange="registraClavePresupModificada(this.id.substring(11))"/></td>';
		tds += '<td><input type="button" name="elimina" id="elimina'+nuevaFila+'"  value="" class="btnElimina"   onclick="eliminarClavePresup(this.id)" /></td>';
		tds += '<td><input type="button" name="agrega" id="agrega'+nuevaFila+'"  value="" class="btnAgrega" onclick="agregaClavePresupuestal()"/></td>';
		tds += '</tr>';
	$('#numero').val(nuevaFila);
	$("#miTabla").append(tds);
	agregarTiposClavePresupCombo('tipoClavePresupID' + nuevaFila);
	agregaFormatoControles('gridAltaClavePresup');
	agregaFormatoControles('formaGenerica');
	return false;
}

/* ========================== FUNCION CONSULTAR GRID CLAVE PRESUPUESTAL ====================*/
function consultaGridClavePresup(){
	var params = { };
	params['tipoLista'] = 1;

	$.post("clavePresupGridVista.htm", params, function(data){
		if(data.length > 0) {
			$('#gridAltaClavePresup').html(data);
			$('#gridAltaClavePresup').show();
			$('#divClasifica').show();
			agregaFormatoControles('gridAltaClavePresup');
            $('#miTabla').pageMe({pagerSelector:'#miPage',showPrevNext:true,hidePageNumbers:false,perPage:30});
		}else{
			$('#gridAltaClavePresup').html("");
			$('#gridAltaClavePresup').show();
			$('#divClasifica').show();
		}
	});
}

/* ============================= FUNCION ELIMINAR REGLON DEL GRID ======================== */
function eliminarClavePresup(control) {
	habilitaBoton('graba', 'submit');
	var numero = control.substr(7,control.length);
	var jqIdAsignado = eval("'nomClasifClavPresupID" + numero+ "'");
	var valorAsig = document.getElementById(jqIdAsignado).value;

	if(valorAsig > 0 ){
		mensajeSis("La Clave Presupuestal a Eliminar se encuentra Asociada con una Clasificación de Clave Presupuestal");
		return false;
	}

	registraClavePresupEliminada(numero);
	$("#renglonClave" + numero).remove();
	$('#numero').val(consultaFilasClavePresup());
	reordenamientosImputs();
}

function registraClavePresupEliminada(numeroFila) {
	var idClavePresup = $("#nomClavePresupID" + numeroFila).val();
	if(parseInt(idClavePresup)==0) {
		return;
	}
	
	listaClavesPresupBaja.push(idClavePresup);
	$('#clavesPresupBaj').val(listaClavesPresupBaja.toString());
}

function registraClavePresupModificada(numeroFila) {
	habilitaBoton('graba', 'submit');
	var idClavePresup = $("#nomClavePresupID" + numeroFila).val();
	if(parseInt(idClavePresup)==0) {
		return;
	}
	
	for(var i = 0; i < listaClavesPresupMod.length; i++) {
		if(listaClavesPresupMod[i] == idClavePresup) {
			return;
		}
	}
	
	listaClavesPresupMod.push(idClavePresup);
	$('#clavesPresupMod').val(listaClavesPresupMod.toString());
}

function limpiaCampos(){
}

function consultaFilasClavePresup(){
	var totales=0;
	$('tr[name=renglonClave]').each(function() {
		totales++;
	});
	return totales;
}

/* ======================== FUNCION DE REORDENAMIENTO DE CONTROLES =============================== */
function reordenamientosImputs(){
	var contador = 1;
	$('tr[name=renglonClave]').each(function() {
		$(this).attr('id', 'renglonClave' + contador);
		$('#'+ $(this).find("input[name^='consecutivoID']").attr('id')).attr('id', 'consecutivoID' + contador);
		$('#'+ $(this).find("input[name^='consecutivoID']").attr('id')).attr('value', contador);
		$('#'+ $(this).find("input[name^='nomClavePresupID']").attr('id')).attr('id', 'nomClavePresupID' +   contador);
		$('#'+ $(this).find("input[name^='nomClasifClavPresupID']").attr('id')).attr('id', 'nomClasifClavPresupID' +   contador);
		$('#'+ $(this).find("select[name^='tipoClavePresupID']").attr('id')).attr('id', 'tipoClavePresupID' +   contador);
		$('#'+ $(this).find("input[name^='reqClave']").attr('id')).attr('id', 'reqClave' +   contador);
		$('#'+ $(this).find("input[name^='clave']").attr('id')).attr('id', 'clave' +   contador);
		$('#'+ $(this).find("input[name^='descripcion']").attr('id')).attr('id', 'descripcion' +  contador);
		$('#'+ $(this).find("input[name^='elimina']").attr('id')).attr('id', 'elimina' +  contador);
		$('#'+ $(this).find("input[name^='agrega']").attr('id')).attr('id', 'agrega' +  contador);

		contador++;
	});
}

/* ============================== FUNCION PARA LISTAR LOS TIPOS DE CLAVES PRESUPUESTALES ================= */
function consultarTiposClavePresup(){
	tipoClavePresupServicio.lista(2,{}, function(tiposClavePresup){
		listaTiposClavesPresup = tiposClavePresup;
	});
}

function agregarTiposClavePresupCombo(idControl){
	dwr.util.addOptions(idControl, listaTiposClavesPresup, 'nomTipoClavePresupID', 'descripcion');
}

/*================================== FUNCION PARA VERIFICAR CAMPOS VACIOS ================================== */
function verificarvacios(){
	quitaFormatoControles('divGridTipoClavePresup');
	var numCodig = $('#numero').val();
	for(var i = 1; i <= numCodig; i++){
		var jqIdAsi = eval("'descripcion" + i+ "'");
		var descripcion = document.getElementById(jqIdAsi).value;
		if (descripcion == ""){
			document.getElementById(jqIdAsi).value='';
			$(descripcion).addClass("error");
			descripcionID = i;
			return 1; 
		}

		var jqIdClave = eval("'clave" + i+ "'");
		var jqIdReqClave = eval("'reqClave" + i+ "'");
		var clave = document.getElementById(jqIdClave).value;
		var reqClave = document.getElementById(jqIdReqClave).value;
		document.getElementById(jqIdClave).disabled = false;
		if (clave == "" && reqClave == 'S'){
			document.getElementById(jqIdClave).value='';
			$(descripcion).addClass("error");
			clave = i;
			return 2; 
		}
	}
	agregaFormatoControles('divGridTipoClavePresup'); 
}

/* =================== FUNCION PARA GUARDAR LA INFORMACION DE CLAVES PRESUPUESTALES ===================== */
function grabarTransacion(){
	var mandar = verificarvacios();
	if(mandar != 1){
		if(mandar != 2){
			$('#tipoTransaccion').val(catTipoTransaccionClavePresup.agrega);
			agregaFormatoControles('divGridTipoClavePresup');
		}else{
			mensajeSis("La Clave del Número : " + clave + " es Requerido");
			return false;
		}
	}else {
		mensajeSis("La descrición del Número : " + descripcionID + " es Requerido");
		return false;
	}
}

/*==================  FUNCIONALIDAD QUE CONSULTA EL TIPO DE CLAVE PRESUPUESTAL ============================== */
function consultaTipoClavePresup(control) {
	var tipoClavePresupID = document.getElementById(control).value;

	if(tipoClavePresupID != '' && !isNaN(tipoClavePresupID)){
		var tipoClavePresupBean = { 
			'nomTipoClavePresupID': tipoClavePresupID
		};
		tipoClavePresupServicio.consulta(1,tipoClavePresupBean,function(tipoClavePresp) {
			if(tipoClavePresp != null){

				var reqClave = tipoClavePresp.reqClave;
				var numero = control.substr(17,control.length);
				var jqIdAsignado = eval("'clave" + numero+ "'");

				var jqIdReqClave = eval("'reqClave" + numero+ "'");

				if(reqClave == 'S'){
					$("#" + jqIdReqClave ).val(reqClave);
					$("#" + jqIdAsignado ).val("");
					document.getElementById(jqIdAsignado).disabled = false;
				}

				if(reqClave == 'N'){
					$("#" + jqIdReqClave ).val(reqClave);
					$("#" + jqIdAsignado ).val("");
					document.getElementById(jqIdAsignado).disabled = true;
				}
			}
		});
	}
}

/* ============= CONSULTA DE LAS CLAVES PRESUPUESTALES ============ */
function consulClavesPresupuestalesCombo(){
	var tipoCon=2;
	var bean = {
	};

	dwr.util.removeAllOptions('nomClavesPresupID');
	clavePresupServicio.lista(tipoCon,bean, function(clavesPresup){
		dwr.util.addOptions('nomClavesPresupID', {'0':'SELECCIONAR TODO'});
		dwr.util.addOptions('nomClavesPresupID', clavesPresup, 'nomClavePresupID', 'descripcion');
	});
}

/*==================== FUNCION PARA VALIDAR QUE SOLO SE ACEPTE NUMERO =================*/
function validador(e){
	key=(document.all) ? e.keyCode : e.which;
	if (key < 48 || key > 57){
		if (key==8 || key == 0){
			return true;
		}
		else
			mensajeSis("sólo se pueden ingresar números");
			return false;
	}
}

function seleccionaTodosClavesPresup() {
	$("#nomClavesPresupID option").each(function(){
		var idClavePresup = $(this).attr('value');
		var jqOpcion = eval("'#nomClavesPresupID option[value="+ idClavePresup +"]'");
		if (idClavePresup > 0 && idClavePresup!=""){
			$(jqOpcion).attr("selected","selected");
			$("#nomClavesPresupID option[value=0]").attr("selected",false);
		}
	});
}

/*==================  FUNCIONALIDAD QUE CONSULTA DE CLASIFICACION CLAVE PRESUPUESTAL ========================= */
function consultaClasifClavePresup(control) {
	var nomClasifClavPresupID = $('#nomClasifClavPresup').val();
	setTimeout("$('#cajaLista').hide();", 200);
	if(nomClasifClavPresupID != '' && !isNaN(nomClasifClavPresupID)){
		var clasifClavePresupBean = { 
			'nomClasifClavPresupID': nomClasifClavPresupID
		};
		clasifClavePresupServicio.consulta(1,clasifClavePresupBean,function(clasifClavePresp) {
			if(clasifClavePresp != null){
				$('#descripClasifClave').val(clasifClavePresp.descripcion);
				$('#estatus').val(clasifClavePresp.estatus);
				$('#prioridad').val(clasifClavePresp.prioridad);
				var clavesPresup = clasifClavePresp.nomClavePresupID;
				consultaComboClavePresup(clavesPresup);
				habilitaControl('estatus');
				deshabilitaBoton('grabaClsif', 'submit');
				habilitaBoton('modificaClasif', 'submit');
			}else{
				mensajeSis('La Clasificación de Clave Presupuestal no Existe');
			}
		});
	}
}

function consultaComboClavePresup(clavesPresup) {
	var clavePresup= clavesPresup.split(',');
	var tamanio = clavePresup.length;
	for (var i=0;i<tamanio;i++) {
		var clave = clavePresup[i];
		var jqClave = eval("'#nomClavesPresupID option[value="+clave+"]'");
		$(jqClave).attr("selected","selected");
	}
}

/* ========================== FUNCION CONSULTAR GRID CLASIFICACION DE CLAVE PRESUPUESTAL ====================*/
function consultaGridClasifClavePresup(){
	var params = { };
	params['tipoLista'] = 2;

	$.post("clasifClavePresupGirdVista.htm", params, function(data){
		if(data.length > 0) {
			$('#gridClasifClavePresup').html(data);
			$('#gridClasifClavePresup').show();
			agregaFormatoControles('gridClasifClavePresup');
		}else{
			$('#gridClasifClavePresup').html("");
			$('#gridClasifClavePresup').show();
		}
	});
}

/* ============= CONSULTA DE LAS CLAVES PRESUPUESTALES ============ */
function consulClavePresupCombo(){
	var numCodig = $('#numeroClavConv').val();
	var tipoCon=3;

	for(var i = 1; i <= numCodig; i++){
		var  jqIdNomClasifClavPresupID = eval("'clasifClavPresupID" + i + "'");
		var  nomClasifClavPresupID = document.getElementById(jqIdNomClasifClavPresupID).value;
		var  jqIdNomClavePresupID = eval("'clavePresupID" + i+ "'");

		var bean = {
			'nomClasifClavPresupID' : nomClasifClavPresupID
		};

		dwr.util.removeAllOptions(jqIdNomClavePresupID);
		clasifClavePresupServicio.lista(tipoCon,bean, { async: false,callback: function(clavesPresup){
			dwr.util.addOptions(jqIdNomClavePresupID, clavesPresup, 'nomClavePresupID', 'descripcion');
		}});
	}
}

function validaClave(control){
	var clave = document.getElementById(control).value;
	var numerocaracteresClave = clave.length;

	if (numerocaracteresClave > 8) {
		mensajeSis('La Clave Presupuestal no puede Ser Mayor de 8 Carácteres');
	}
}
