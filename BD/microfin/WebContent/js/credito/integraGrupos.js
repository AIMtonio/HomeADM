$(document).ready(
		
function() {
		esTab = true;
		////variables globales para la agregacion y validacion de integrantes a un grupo comparandolos contra maximos y minimos
		nintegrantes=0;//numero de integrantes en el grupo
		nhombres=0;//numero de hombres en el grupo
		nmujeres=0;//numero de mujeres en el grupo
		nmujeress=0;//numero de mujeres en el grupo
		max=0;//máximo de integrantes que acepta el grupo dependiendo del tipo producto 
		min=0;//mínimo de integrantes que acepta el grupo dependiendo del tipo producto
		maxh=0;//máximo de integrantes que acepta el grupo dependiendo del tipo producto
		minh=0;//mínimo de integrantes que acepta el grupo dependiendo del tipo producto
		maxm=0;//máximo de integrantes que acepta el grupo dependiendo del tipo producto
		minm=0;//mínimo de integrantes que acepta el grupo dependiendo del tipo producto
		maxms=0;//máximo de integrantes que acepta el grupo dependiendo del tipo producto
		minms=0;//mínimo de integrantes que acepta el grupo dependiendo del tipo producto
		productoCreditoID=0;//guarda el producto de credito para asignarselo al grupo
		
		// Definicion de Constantes y Enums
		var catTipoTransaccionGrupos = {
			'grabar' : '1'
			
		};
//		var catTipoConsultaEmpleados = {
//				'principal' : 1,
//				'foranea'	: 2,
//		};
					
		
		
		
		//------------ Metodos y Manejo de Eventos -----------------------------------------
		
		   deshabilitaBoton('grabar', 'submit');
		   agregaFormatoControles('formaGenerica');
	  		$('#grupoID').focus();
		  
			$(':text').focus(function() {
				esTab = false;
			});

			$(':text').bind('keydown', function(e) {
				if (e.which == 9 && !e.shiftKey) {
					esTab = true;
				}
			});

				
			
			
			 $('#grupoID').blur(function() {
					esTab=true;
					consultaGrupo($('#grupoID').attr("ID"));
					consultaDatosGrupales();//se consultan los datos que son relacionados al producto segun el grupo
					inicializaGlobalesGrupalesGrid();
				});
			 
			 $('#grupoID').bind('keyup',function(e){
				 if(this.value.length >= 2){ 
					var camposLista = new Array(); 
				    var parametrosLista = new Array(); 
				    	camposLista[0] = "nombreGrupo";
				    	parametrosLista[0] = $('#grupoID').val();
				 listaAlfanumerica('grupoID', '1', '1', camposLista, parametrosLista, 'listaGruposCredito.htm'); } });
			
							 
			$.validator.setDefaults({
				
		            submitHandler: function(event) { 
						$('#tipoTransaccion').val(catTipoTransaccionGrupos.grabar);
						if(crearIntegrantes()){
							return false;
						}
		                   grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','grupoID'); 
		                  
		            }


		    });	
				
		
		
			
			//------------ Validaciones de la Forma -------------------------------------
			
			$('#formaGenerica').validate({
						
				rules: {
					
					grupoID: {
						required: true
					}
			
				},		
				messages: {
					
				
					grupoID: {
						required: 'Especificar Grupo.'
					}
					
					}		
			});
			
//------------ Validaciones de Controles -------------------------------------
	
			// ////////////////funcion consultar grupo//////////////////
			
function consultaGrupo(idControl) {
	var jqGrupo = eval("'#" + idControl + "'");
	var numGrupo = $(jqGrupo).val();
	var conGrupo = 1;
	var GrupoBeanCon = {
			'grupoID' : numGrupo
		};
	setTimeout("$('#cajaLista').hide();", 200);

	
	
	if (numGrupo != '' && !isNaN(numGrupo) && esTab) {
		gruposCreditoServicio.consulta(conGrupo,
				GrupoBeanCon, function(grupo) {
					if (grupo != null) {
						if(grupo.cicloActual != 0 && grupo.estatusCiclo=='A'){
						$('#nombreGrupo').val(grupo.nombreGrupo);
						$('#cicloActual').val(grupo.cicloActual);
						$('#estatusCiclo').val(grupo.estatusCiclo);
						$('#fechaRegistro').val(grupo.fechaRegistro);
						$('#grabar').show();
						habilitaBoton('grabar', 'submit');
						
						esTab=true;
						consultaDetalle(false);
							
						}
							else{
								if (grupo.cicloActual == 0 && grupo.estatusCiclo=='N'){
									mensajeSis("El grupo debe estar Abierto para Asignar Integrantes");
									deshabilitaBoton('grabar', 'submit');
									$('#grabar').hide();
									$('#nombreGrupo').val(grupo.nombreGrupo);
									$('#cicloActual').val(grupo.cicloActual);
									$('#estatusCiclo').val(grupo.estatusCiclo);
									$('#fechaRegistro').val(grupo.fechaRegistro);
									$('#gridIntegrantes').hide();
								}
								else{
									if (grupo.cicloActual != 0 && grupo.estatusCiclo=='C'){
										mensajeSis("El grupo debe estar Abierto para Asignar Integrantes");
										esTab=true;
										consultaDetalle(true);
										deshabilitaBoton('grabar', 'submit');
										$('#grabar').hide();
										$('#nombreGrupo').val(grupo.nombreGrupo);
										$('#cicloActual').val(grupo.cicloActual);
										$('#estatusCiclo').val(grupo.estatusCiclo);
										$('#fechaRegistro').val(grupo.fechaRegistro);
										
									}
									
								}
								
						}
					} else {

						mensajeSis("No Existe el grupo");
						deshabilitaBoton('grabar', 'submit');
						inicializaForma('formaGenerica','grupoID');
						$('#cicloActual').val('');
						$('#estatusCiclo').val("N").selected = true;
						$('#gridIntegrantes').hide();
						$('#grabar').hide();
				  		$('#grupoID').val("");
				  		$('#grupoID').focus();
					} 
				});
	}
}
			
			
			
			
/////consulta GridIntegrantes////////////

function consultaDetalle(isDisabled){	
	var params = {};
//	var tipoConsultaprinc = 1;
	params['tipoLista'] = 1;
	params['grupoID'] = $('#grupoID').val();
	
	$.post("listaIntegrantesGpo.htm", params, function(data){
			if(data.length >0) {		
					$('#gridIntegrantes').html(data);
					$('input[name=productCre]').each(function() {
						var jqCicInf = eval("'#" + this.id + "'");
						productoCreditoID = $(jqCicInf).asNumber();
					});
					
						
						$('input[name=elimina]').each(function() {
							var jqdbuttonse = eval("'#" + this.id + "'");
							if(isDisabled){
								$('#agregaIntegrante').attr('disabled',true);
								$(jqdbuttonse).attr('disabled',true);
								var jqdbuttonsa = eval("'#agrega" + this.id + "'");
								$(jqdbuttonsa).attr('disabled',true);
							}
				
						});
					consultaDatosGrupales();//se consultan los datos que son relacionados al producto segun el grupo
					inicializaGlobalesGrupalesGrid();
					$('#gridIntegrantes').show();					
			}else{				
					$('#gridIntegrantes').html("");
					$('#gridIntegrantes').show();
			}
			
			
			 	
			
	});
}



/////funcion para Crear Integrantes de Grupo////////////			

function crearIntegrantes(){	
	var mandar = verificarvacios();
	if(mandar!=1){   		  		
   	quitaFormatoControles('gridIntegrantes');
		var numDetalle = $('input[name=consecutivoID]').length;
		$('#integrantes').val("");
		var idr;
		var indice;
		for(var i = 1; i <= numDetalle; i++){
			idr = eval('cargo'+i);
			indice = idr.selectedIndex;
			if(i == 1){
			$('#integrantes').val($('#integrantes').val() +
			$('#grupoID').val() + ']' +
			document.getElementById("solicitudCre"+i+"").value + ']' +
			document.getElementById("clienteID"+i+"").value + ']' +
			document.getElementById("prospectoID"+i+"").value + ']' +
			document.getElementById("estatusCiclo").value + ']' +
			document.getElementById("fechaRegistro").value  + ']' +
			document.getElementById("cicloActual").value  + ']' +
			document.getElementById("productCre"+i+"").value  + ']' +
			indice);
			}else{
				
				
				$('#integrantes').val($('#integrantes').val() + '[' +
				
						$('#grupoID').val() + ']' +
						document.getElementById("solicitudCre"+i+"").value + ']' +
						document.getElementById("clienteID"+i+"").value + ']' +
						document.getElementById("prospectoID"+i+"").value + ']' +
						document.getElementById("estatusCiclo").value + ']' +
						document.getElementById("fechaRegistro").value  + ']' +
						document.getElementById("cicloActual").value  + ']' +
						document.getElementById("productCre"+i+"").value  + ']' +
						indice);
			}
	}	
}
else{
	mensajeSis("Especifica Cargo");
	return true;
//		event.preventDefault();
	}
	return false;
}
				
/////funcion para verificar que no existan datos vacios////////////

function verificarvacios(){	
	var variable = 2; 
	quitaFormatoControles('gridIntegrantes');
var numDetalle = $('input[name=consecutivoID]').length;
$('#integrantes').val("");

for(var i = 1; i <= numDetalle; i++){
	
	var idcc = document.getElementById("solicitudCre"+i+"").value;
		if (idcc ==""){
			document.getElementById("solicitudCre"+i+"").focus();				
		$(idcc).addClass("error");	
		variable= 1; 
			}else{
				variable=2;
			}
	var idcco = document.getElementById("clienteID"+i+"").value;
		if (idcco ==""){
			document.getElementById("clienteID"+i+"").focus();
		$(idcco).addClass("error");
		variable= 1; 
		}else{
			variable=2;
		}
	var idr = document.getElementById("prospectoID"+i+"").value;
		if (idr ==""){
			document.getElementById("prospectoID"+i+"").focus();
		$(idr).addClass("error");
		variable= 1; 
		}else{
			variable=2;
		}
	var ida = document.getElementById("estatusCiclo").value;
		if (ida ==""){
			document.getElementById("estatusCiclo").focus();
		$(ida).addClass("error");
		variable= 1; 
		}else{
			variable=2;
		}
	var ide = document.getElementById("fechaRegistro").value;
		if (ide ==""){
			document.getElementById("fechaRegistro").focus();
		$(ide).addClass("error");
		variable= 1; 
		}else{
			variable=2;
		}
	var idi = document.getElementById("cicloActual").value;
		if (idi ==""){
			document.getElementById("cicloActual").focus();
		$(idi).addClass("error");
		variable= 1; 
		}else{
			variable=2;
		}
		
	var idr = eval('cargo'+i);
	 var indice = idr.selectedIndex;
//      var valor = idr.options[idr.selectedIndex].text;
     
      
		if (indice ==0){
			"document.gridIntegrantes.cargo"+i+".focus";
		$(indice).addClass("error");
			variable= 1; 
			}else{
				variable=2;
			}
		
	}
	return variable;
}

});	// fin de document ready	




/////Funcion para listar la solicitud en el Grid////////////

function listaSolicitud(idControl){
	var jq = eval("'#" + idControl + "'");
	
	$(jq).bind('keyup',function(e){
	var jqControl = eval("'#" + this.id + "'");
	var num = $(jqControl).val();
		
	var camposLista = new Array();
	var parametrosLista = new Array();			
	camposLista[0] = "clienteID"; 
	parametrosLista[0] = num;
	
	lista(idControl, '1', '4', camposLista, parametrosLista, 'listaSolicitudCredito.htm');
	});
}


//////////////////funcion consultar solicitud en el Grid//////////////////

function consultaSolicitudGrid(idControl){//, puesto){ 		
	var jqSolicitud = eval("'#" + idControl + "'");
	var sbtrn = (idControl.length);
	var Control= idControl.substr(12,sbtrn);
	setTimeout("$('#cajaLista').hide();", 200);
	
	var numSolicitud = $(jqSolicitud).val();
	var nombre = eval("'#nombre"+Control+"'");
	var sexo = eval("'#sexo"+Control+"'");
	var estadoCivil = eval("'#estadoCivil"+Control+"'");
	
	var clienteID = eval("'#clienteID"+Control+"'");
	var prospectoID = eval("'#prospectoID"+Control+"'");
	var montoSol = eval("'#montoSol"+Control+"'");
	var montoAu = eval("'#montoAu"+Control+"'");
	var productCre = eval("'#productCre"+Control+"'");
	
	var cargo = eval("'#cargo"+Control+"'");
	
	
	var conPrincipal = 1;
	var solicitudBeanCon = {
	  'solicitudCreditoID':numSolicitud
	};
	

esTab = true;

if(numSolicitud != '' && !isNaN(numSolicitud) && esTab){
solicitudCredServicio.consulta(conPrincipal,solicitudBeanCon,function(solicitud){
	
	var consultaIntegranteGrupo = 3;
	var bean={
			'solicitudCreditoID':numSolicitud
	};
	
	integraGruposServicio.consulta(consultaIntegranteGrupo,bean,function(integrante){
		if(integrante!=null){
			if(integrante.cargo!=null){
				$(cargo).val(integrante.cargo);
			}
		}
	});
	if(solicitud!=null){
		$(clienteID).val(solicitud.clienteID);
		$(prospectoID).val(solicitud.prospectoID); 
		$(montoSol).val(solicitud.montoSolici);
		$(montoAu).val(solicitud.montoAutorizado);
		if (productCre=='#productCre1'){
			$(productCre).val(solicitud.productoCreditoID);
			productoCreditoID=solicitud.productoCreditoID;
		}
		if (productCre!='#productCre1'){
			var comPro1= parseInt($('#productCre1').asNumber());
			$(productCre).val(solicitud.productoCreditoID);
			var comPro2=parseInt($(productCre).asNumber());
			if (comPro2!=comPro1){
				mensajeSis("la Solicitud no corresponde al mismo Producto de Crédito que la anterior");
				$(jqSolicitud).val("");
				$(clienteID).val("");
				$(prospectoID).val("");
				$(montoSol).val("");
				$(montoAu).val("");
				$(sexo).val("");
				$(estadoCivil).val("");
				$(productCre).val("");
				$(nombre).val("");
				$(jqSolicitud).focus();
			}
		}
		
		if (solicitud.estatus == 'C' || solicitud.estatus == 'R' || solicitud.estatus == 'D'){
			if(solicitud.estatus == 'C'){mensajeSis("No se pueden aceptar solicitudes Canceladas");}
			if(solicitud.estatus == 'R'){mensajeSis("No se pueden aceptar solicitudes Rechazadas");}
			if(solicitud.estatus == 'D'){mensajeSis("No se pueden aceptar solicitudes Desembolsadas");}
			
			$(jqSolicitud).val("");
			$(clienteID).val("");
			$(prospectoID).val("");
			$(montoSol).val("");
			$(montoAu).val("");
			$(sexo).val("");
			$(estadoCivil).val("");
			$(productCre).val("");
			$(nombre).val("");
			$(jqSolicitud).focus();
		}
		
		if(solicitud.clienteID!=0 && solicitud.prospectoID==0){
			esTab = true;
			consultaNombreGrid(clienteID, nombre, sexo, estadoCivil,Control);
		}
		else{
			if(solicitud.clienteID==0 && solicitud.prospectoID!=0){
				esTab = true;
				consultaProspectoGrid(prospectoID, nombre, sexo, estadoCivil,Control);
			}
			else{
				if(solicitud.clienteID==0 && solicitud.prospectoID==0){
					esTab = true;
					consultaNombreGrid(clienteID, nombre, sexo, estadoCivil,Control);
				}
			}
		}
		
		
		habilitaBoton('grabar',' submit' );
	}  
	else{
		deshabilitaBoton('grabar','submit');
		mensajeSis("Solicitud de Crédito No Grupal o Estatus Incorrecto");
		$(jqSolicitud).val("");
		$(clienteID).val("");
		$(prospectoID).val("");
		$(montoSol).val("");
		$(montoAu).val("");
		$(sexo).val("");
		$(estadoCivil).val("");
		$(productCre).val("");
		$(nombre).val("");
		$(jqSolicitud).focus();
	}
	});



}

}


//////////////////funcion consultar nombre de cliente////////////////
function consultaNombreGrid(idControl, nom, sex, estadoc, Control) {
	var jqCliente = idControl;
	var numCliente = $(jqCliente).val();
	var nombre = nom;
	var sexo = sex;
	var estadoCivil = estadoc;
	
	
	setTimeout("$('#cajaLista').hide();", 200);
	
	if(numCliente != '' && !isNaN(numCliente) && esTab){
	clienteServicio.consulta(1,	numCliente, function(cliente) {
	
				if (cliente != null) {
					$(nombre).val(cliente.nombreCompleto);//consulte los datos de sexo, estado civil para inicializar los datos  de grupo  y su validacion
					$(sexo).val(cliente.sexo);
					$(estadoCivil).val(cliente.estadoCivil);
					consultaDatosGrupales();
					validaDatosGrupales(Control);
				} 
				else{
					$(nombre).val("");
					$(sexo).val("");
					$(estadoCivil).val("");
				}
			});
	}
}


//////////////////funcion consultar nombre del propecto////////////////
function consultaProspectoGrid(idControl, fila, sex, estadoc,Control) {
	var jqProspecto = idControl;
	var numProspecto = $(jqProspecto).val();
	var nombre = fila;
	var sexo = sex;
	var estadoCivil = estadoc;

	var prospecBeanCon = {
		  'prospectoID':numProspecto
		};
	setTimeout("$('#cajaLista').hide();", 200);
	if(numProspecto != '' && !isNaN(numProspecto) && esTab){
	prospectosServicio.consulta(1,	prospecBeanCon, function(prospecto) {
				if (prospecto != null) {
					$(nombre).val(prospecto.nombreCompleto);
				$(sexo).val(prospecto.sexo);
				$(estadoCivil).val(prospecto.estadoCivil);
				consultaDatosGrupales();
				validaDatosGrupales(Control);
				} 
				else{
					$(nombre).val("");
				}
			});
	}
}


////////funcion para Validar los datos grupales
function validaDatosGrupales(id){
	inicializaGlobalesGrupalesGrid();//lee los datos del grid y los almacena nintegrantes,nhombres, nmujeres, nmujeress y los compara con los datos obtenidos en inicializaGlobalesGrupalesGrid();
	var estadoCivil = eval("'#estadoCivil"+id+"'");
	var nmujeresc = nmujeres - nmujeress;
	var maxmc = maxm-minms;
	if(nintegrantes 	>  max){
		
		
		if(max==0 || nintegrantes == 1){ return false;
		}else{
			limpiaUltimaFilaGrid(id);
			inicializaGlobalesGrupalesGrid();
			mensajeSis('Se ha alcanzado el Número Máximo de Integrantes para el Grupo');
			return true;
		}
		
		}
	if(nhombres 	> 	maxh){
		limpiaUltimaFilaGrid(id);
		inicializaGlobalesGrupalesGrid();
		if(maxh == 0){
			mensajeSis('El Producto de Crédito no Admite Hombres.');  
		}else{
			mensajeSis('Se ha alcanzado el Número Máximo de Hombres para el Grupo');
		}
		   
		return true;}
	if(nmujeres 	> 	maxm){
		limpiaUltimaFilaGrid(id);
		inicializaGlobalesGrupalesGrid();
		if(maxm == 0){
			mensajeSis('El Producto de Crédito no Admite Mujeres.');
		}else{
			mensajeSis('Se ha alcanzado el Número Máximo de Mujeres para el Grupo');	
		}
		return true;}
	if(nmujeress 	> 	maxms){
		limpiaUltimaFilaGrid(id);
		inicializaGlobalesGrupalesGrid();
		if(maxms == 0){
			mensajeSis('El Producto de Crédito no Admite Mujeres Solteras.');
		}else{
			mensajeSis('Se ha alcanzado el Número Máximo de Mujeres Solteras para el Grupo');
		}
		return true;}
	if(nmujeresc 	> 	maxmc && $(estadoCivil).val() != 'S' ){
		limpiaUltimaFilaGrid(id);
		inicializaGlobalesGrupalesGrid();
		if(maxmc == 0){
			mensajeSis('El Producto de Crédito Solo Admite Mujeres Solteras.');
		}else{
		mensajeSis('Se has alcanzado el Número Máximo de Mujeres con Estado Civil Diferente de Solteras para el Grupo');
		}	
	return true;}
	
	
	return false;//sin errores
}

function limpiaUltimaFilaGrid(id){// limpia los datos del grid cuando la ultima fila esta incorrecta y no se puede agregar
	var jqSolicitud = eval("'#solicitudCre"+id+"'");
	$(jqSolicitud).val("");
	var nombre = eval("'#nombre"+id+"'");
	$(nombre).val("");
	var sexo = eval("'#sexo"+id+"'");
	var estadoCivil = eval("'#estadoCivil"+id+"'");
	var clienteID = eval("'#clienteID"+id+"'");
	$(clienteID).val("");
	var prospectoID = eval("'#prospectoID"+id+"'");
	$(prospectoID).val("");
	var montoSol = eval("'#montoSol"+id+"'");
	$(montoSol).val("");
	var montoAu = eval("'#montoAu"+id+"'");
	$(montoAu).val("");
	var productCre = eval("'#productCre"+id+"'");
	$(productCre).val("");
	$(jqSolicitud).val("");
	$(clienteID).val("");
	$(prospectoID).val("");
	$(montoSol).val("");
	$(montoAu).val("");
	$(sexo).val("");
	$(estadoCivil).val("");
	$(productCre).val("");
	$(nombre).val("");
	$(jqSolicitud).focus();
}


function inicializaGlobalesGrupalesGrid(){//lee los datos del grid y obtiene el numero de integrantes numero de mujeres  y mujeres solteras
	var jqCicInf = '';
	var jqCicInf2 = '';
	nintegrantes =0;
	nhombres=0;
	nmujeres=0;
	nmujeress=0;
	var numDeta = $('input[name=sexo]').length;
	nintegrantes = numDeta;
	for(var i = 1; i <= numDeta; i++){
		jqCicInf = eval("'#sexo" +i+ "'");
		jqCicInf2 = eval("'#estadoCivil" +i+ "'");
		if($(jqCicInf).val()=='F'){
			nmujeres=nmujeres+1;
			if($(jqCicInf2).val()=='S'){nmujeress=nmujeress+1;}
		}
		if($(jqCicInf).val()=='M'){nhombres=nhombres+1;}
	}
	if(numDeta == 0){
		nhombres = 0;
		nmujeres = 0;
		nmujeress = 0;
		$('#inte').val(Number(nhombres+nmujeres));
		$('#inteh').val(nhombres);
		$('#intem').val(nmujeres);
		$('#intems').val(nmujeress);
	}else{
	$('#inte').val(Number(nhombres+nmujeres));
	$('#inteh').val(nhombres);
	$('#intem').val(nmujeres);
	$('#intems').val(nmujeress);
	}
}



function consultaDatosGrupales( ){//id control se refiere al dato que esta tomando de el espacio select, input de la forma para procesar la informacion
	var proCredBean='';	
	var numDeta = $('input[name=sexo]').length;
	if (numDeta == 0 || productoCreditoID==0){
		max 	= Number(0);
		min		= Number(0);
		maxh	= Number(0);
		minh	= Number(0);
		maxm	= Number(0);
		minm	= Number(0);
		maxms	= Number(0);
		minms	= Number(0);
		$('#max').val(max);
		$('#min').val(min);
		$('#maxh').val(maxh);
		$('#minh').val(minh);
		$('#maxm').val(maxm);
		$('#minm').val(minm);
		$('#maxms').val(maxms);
		$('#minms').val(minms);
		productoCreditoID = 0;
		return;
		
	}
	proCredBean = {
			  'producCreditoID':productoCreditoID
			};


	productosCreditoServicio.consulta(4,	proCredBean, function(procred) {
		if(procred != null ){			
		max 	= Number(procred.maxIntegrantes);
		min		= Number(procred.minIntegrantes);
		maxh	= Number(procred.maxHombres);
		minh	= Number(procred.minHombres);
		maxm	= Number(procred.maxMujeres);
		minm	= Number(procred.minMujeres);
		maxms	= Number(procred.maxMujeresSol);
		minms	= Number(procred.minMujeresSol);
		$('#max').val(max);
		$('#min').val(min);
		$('#maxh').val(maxh);
		$('#minh').val(minh);
		$('#maxm').val(maxm);
		$('#minm').val(minm);
		$('#maxms').val(maxms);
		$('#minms').val(minms);
		} 
	});
}


function getMax(){//obtiene el numero maxiomo de integrantes por el tipo de producto y lo devuelve para compara para cuando den agregar
	return max;
	
}