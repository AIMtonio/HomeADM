var parametroBean = consultaParametrosSession();
var telefono=parametroBean.telefonoLocal;
var telefonoInt=parametroBean.telefonoInterior;
var sucursal =parametroBean.nombreSucursal;
var rfcInstitucion=parametroBean.rfcRepresentante;
var fecha=parametroBean.fechaSucursal;
var fechaHora = fecha+" " +hora();
var caja=parametroBean.cajaID;
var claveUsuario=parametroBean.claveUsuario;
var nombreInstitucion=parametroBean.nombreInstitucion;
var direccion=parametroBean.dirFiscal;
var rfcInstitucion=parametroBean.rfcInst;
var municipioEstado=parametroBean.edoMunSucursal;


var impresoraTicket=parametroBean.impTicket;
var direccionSucursal=parametroBean.edoMunSucursal;
var imprimeSaldoCredito=parametroBean.impSaldoCred;
var rutaImpTicket=parametroBean.recursoTicketVent;
var applet = document.jzebra;
var Tamañoticket	= 'T';

if($('#nuClave').val() != ''  &&  $('#nuClave').val() != undefined){
	if(parametroBean.tipoImpTicket == Tamañoticket){
		findPrinter();
	}

}




function findPrinter() { 
	if (applet != null) {
		applet.findPrinter(impresoraTicket);
	}             
	monitorFinding();
}




 // funcion que agrega el encabezado del ticket
function agregaEncabezado(folio){        
  if(applet!=null){			  
	  agregaLinea(nombreInstitucion);
	  agregaLinea(direccion);
	  agregaLinea("RFC: "+rfcInstitucion+"  Tel: "+telefono);
	  agregaLinea("Tel.Int: "+telefonoInt);
	  agregaSaltoLinea(1); 
	  agregaLinea("Suc: "+sucursal.substring(0,15)+" "+fecha+" " +hora());
	  agregaLinea("Folio: "+folio+"    Caja: "+caja+" "+claveUsuario);    	      
  }
monitorPrinting();
}
/**
 * Encabezado del ticket
 * @param folio : Numero de Transacción
 * @param fechaTicket: Fecha de la Operación
 * @param horaTicket : Hora de la operación
 */
function agregaEnc(ticketBean) {
	if(applet!=null){
		setVariablesGlobales();
		agregaLinea(nombreInstitucion);
		agregaLinea(direccion);
		agregaLinea("RFC: " + rfcInstitucion);
		agregaSaltoLinea(1);
		var nomSucursal = '';
		if(ticketBean.nombreSucursal!=undefined){
		nomSucursal = ticketBean.nombreSucursal.substring(0, 15);
		}
		agregaLinea("Suc: " + nomSucursal + " " + ticketBean.fecha + " " + ticketBean.hora);
		agregaLinea("Folio: " + ticketBean.folio + "    Caja: " + ticketBean.caja + " " + ticketBean.claveUsuario.toUpperCase());
	}
	monitorPrinting();

}
  
function agregaEncabezadoTira(){        
  if(applet!=null){
	  setVariablesGlobales();
      agregaLinea(nombreInstitucion);
	  agregaSaltoLinea(1); 
	  agregaLinea("Suc: "+sucursal+"    "+"Tel: "+telefono);
	  agregaLinea(direccionSucursal);
	  agregaLinea(fecha+" " +hora());
	  agregaLinea("Usuario: "+claveUsuario+"    Caja: "+caja);    
	     
	  }
  monitorPrinting();   
}

function agregaEncabezadoSofiExpress(folio){
  if(applet !=null){
	 setVariablesGlobales();
	 agregaLinea(nombreInstitucion);
	 agregaLinea(direccion+"RFC: "+rfcInstitucion);
	 agregaLinea("TEL: "+telefonoInt);
	 agregaLinea("SUC: "+sucursal);
	 agregaLinea("TEL.SUC: "+telefono);
	 agregaLinea("FECHA: "+fecha+"   "+hora());
	 if(folio != null) {
		 agregaLinea("FOLIO: "+folio+"    CAJA: "+caja);
	 }	  
  }
 monitorPrinting();
	
}

function agregaEncabezadoSofiExpressAbono(){
  if(applet !=null){
	setVariablesGlobales();
    agregaLinea(municipioEstado);
	agregaLinea(convierteFechaNombre(fecha));  
	agregaLinea(nombreInstitucion);  
	agregaLinea("Sucursal: "+sucursal);		  
	}
    monitorPrinting();
			
}


// funcion para agregar una linea de texto al ticket 
function agregaLinea(lineaTicket) {
	if (applet != null) {   
		 if(lineaTicket.length > 40){    	
			 divideCadena(lineaTicket,40);  
		 }else{    		 
			 applet.append(lineaTicket+"\n");
		 }  
	 }	 
	 monitorPrinting();         
}
      
  // funcion para agregar saltos de Linea 
  function agregaSaltoLinea(numero){
	  for (var i=0;i<numero;i++){				 		 				
		  applet.append("\n");  
	  }
  }
      
      
   // funcion que agrega pie de Pagina Cliente y Cajero
  function agregaPiePagClienteCajero(){     
	  
	  if(applet!=null){    		 
		  applet.append("_______________         _______________"+"\n");
		  applet.append("    CLIENTE      "+"          "+"  CAJERO      "+"\n");
		  applet.append('            "ESTIMADO CLIENTE"'+"\n");
		  applet.append("   Recuerde que su pago puntual le da"+"\n"
				  	   +"   acceso a mas creditos y servicios."+"\n"
				  	   +"  Es importante validar que los datos"+"\n"
				  	   +"  impresos corresponden a la operacion"+"\n"
				  	   +"               solicitada."+"\n"
				  	   +"  Comprobante valido solo con la firma"+"\n" 
				  	   +"        del cajero y cliente"+"\n");
	  }
	  monitorPrinting();   	  
  }
  // funcion que agrega pie de Pagina Socio y Cajero
  function agregaPiePagSocioCajero(){      	      	  
	  if(applet!=null){    		 
		  applet.append("---------------          ---------------"+"\n");		
		  applet.append("    SOCIO      "+"          "+"   CAJERO      "+"\n");
		  applet.append("IMPORTANTE"+"\n");
		  applet.append("Valido solo con la firma del cajero"+"\n");
	  }
	  monitorPrinting();   	  
  }   

  
  // funcion que agrega pie de Pagina Beneficiario y Cajero
  function agregaPiePagClienteCajeroYanga(){      	      	  
	  if(applet!=null){    		 
		  applet.append("---------------          ---------------"+"\n");
		  applet.append(" BENEFICIARIO      "+"     "+"   CAJERO      "+"\n");
		  applet.append("\n");
		  applet.append("IMPORTANTE"+"\n");
		  applet.append("Valido solo con la firma del cajero"+"\n");
	  }
	  monitorPrinting();   	  
  }
  
  // funcion que agrega pie de Pagina solo Cajero  
  function agregaPiePagCajero(){ 
	  if(applet!=null){    		 
		  applet.append("              ---------------          "+"\n");
		  applet.append("                   CAJERO              "+"\n");
		  applet.append("IMPORTANTE"+"\n");
		  applet.append("Valido solo con la firma del cajero"+"\n");
	  }
	  monitorPrinting();   
	  
  }
  
//funcion que agrega pie de Pagina solo Cajero 2 
  function agregaPiePagCajero2(){ 
	  if(applet!=null){    		 
		  applet.append("            ----------------          "+"\n");
		  applet.append("                 CAJERO              "+"\n");
		  applet.append('            "ESTIMADO CLIENTE"'+"\n");
		  applet.append("   Recuerde que su pago puntual le da"+"\n"
				  	   +"   acceso a mas creditos y servicios."+"\n"
				  	   +"  Es importante validar que los datos"+"\n"
				  	   +"  impresos corresponden a la operacion"+"\n"
				  	   +"               solicitada."+"\n"
				  	   +"  Comprobante valido solo con la firma"+"\n" 
				  	   +"        del cajero y cliente"+"\n");
	  }
	  monitorPrinting();   
	  
  }
  
  
//funcion que agrega pie de Pagina solo Socio
  function agregaPiePagSocio(){ 
	  if(applet!=null){    		 
		  applet.append("              ---------------          "+"\n");		
		  applet.append("                   SOCIO              "+"\n");		
	  }
	  monitorPrinting();   
	  
  }
  
    	
  // funcion para mandar a imprimir el ticket (no corta Ticket)
  function imprimeTicket(){
      if (applet != null) {                             
         applet.print();
      }	 
      monitorPrinting();    	  
  }
 
  // Funcion para el Corte del Papel
  function chr(i) {
      return String.fromCharCode(i);
   }
  
  
  // funcion imprime y corta Ticket
 function  imprimeTicketCortaPapel(){	   
   applet.append("\n");
   applet.append("\n");
   applet.append("\n");
   applet.append("\n");
   applet.append("\n");
   applet.append("\n");	    
   applet.append(chr(27) + chr(105));	
   applet.print();	   
 }
      
 // fucnion que solo corta el papel
 function  cortaPapel(){	 
	   applet.append("\n");
	   applet.append("\n");
	   applet.append("\n");
	   applet.append("\n");
	   applet.append("\n");
	   applet.append("\n");	    
	   applet.append(chr(27) + chr(105));	   
 }
  //Funcion para cortar una cadena dependiendo de la longitud y agrega linea(s) al ticket
 function    divideCadena(cadenaOriginal,longitud){	
	var nombres = cadenaOriginal.split(' ');

	var cadena = "";
	var token = "";
	total=nombres.length;
	for(var i=0;i < total;i++){	
		token = nombres[i]+ ' ';			
			if(cadena.length + token.length <=longitud){
				cadena = cadena + token;			
			}
		else{
			if (cadena.length <= longitud) {
				applet.append(cadena+"\n"); 
			}
			cadena = token;			
		}		
	}	
	if (cadena.length <= longitud) {		
		applet.append(cadena+"\n");
	}
}
 
function fechasNombre(){
	var nombreMes='';
	var parametroBea = consultaParametrosSession();
	var fechasApl= parametroBea.fechaAplicacion;	
	 var arreglo = fechasApl.split('-');
	 var anio= arreglo[0];
	 var mes=arreglo[1];
	 var dia=arreglo[2];
	
	 if(mes==01){
		 nombreMes='Enero';
	 }else if(mes == '02'){
			 nombreMes='Febrero';
		 
	 } else if(mes == '03'){
			 nombreMes='Marzo';
		 
	 } else if(mes == '04'){
			 nombreMes='Abril';
		 
	 }else if(mes == '05'){
			 nombreMes='Mayo';
		 
	 } else if(mes == '06'){
			 nombreMes='Junio';
		 
	 } else if(mes == '07'){
			 nombreMes='Julio';
		 
	 } else if(mes == '08'){
			 nombreMes='Agosto';
		 
	 }else if(mes == '09'){
			 nombreMes='Septiembre';
		 
	 } else if(mes == '10'){
			 nombreMes='Octubre';
		 
	 } else if(mes == '11'){
			 nombreMes='Noviembre';
		 
	 } else{
		 nombreMes='Diciembre';
	 }
	
	return  fechaNombre=dia+ " de "+ nombreMes+ " de "+anio;	 	 
}



//Metodo para convertir una cantidad en Letras y agrega la linea
 function cantidadEnLetras(monto){  
	var montoEnLetras='';
	var numeromonedaBase=parametroBean.numeroMonedaBase;
	var simboloMonedaBase=parametroBean.simboloMonedaBase;
	var descrpcion=parametroBean.nombreMonedaBase; 				 		
	setTimeout("$('#cajaLista').hide();", 200);
		
	var numeroMonedaBase=Number(numeromonedaBase);
	var simboloString=simboloMonedaBase.toString();
	var descriptcionString=descrpcion.toString();
	
	var n=monto.replace(',','');
 	var montostring=n.toString(); 			
 			
	utileriaServicio.cantidadEnLetrasWeb(montostring,numeroMonedaBase,simboloString,descriptcionString, 
			{ async: false, callback: function (montoLetras) {
				if(montoLetras!=null){	 
					montoEnLetras=montoLetras;					
					agregaLinea(montoEnLetras.replace(/\*/g,''));														
				}
			}
	
			});				
	return montoEnLetras;
  }


// funcion para obtener la hora del sistema
function hora(){
	 var Digital=new Date();
	 var hours=Digital.getHours();
	 var minutes=Digital.getMinutes();
	 var seconds=Digital.getSeconds();
	
	 if (minutes<=9)
		 minutes="0"+minutes;
	 if (seconds<=9)
		 seconds="0"+seconds;
	return  hours+":"+minutes+":"+seconds;
 }
      
      
// *Note:  monitorPrinting() still works but is too complicated and
// outdated.  Instead create a JavaScript  function called 
// "jzebraDonePrinting()" and handle your next steps there.   

function monitorPrinting() {	
	if (applet != null) {
	   if (!applet.isDonePrinting()) {
	      window.setTimeout('monitorPrinting()', 100);
	   }else {
	      var e = applet.getException();	      
	      if(e != null ){
	    	  alert("Error al Imprimir: " + e.getLocalizedMessage());
	      }		     
	   }
	}else{
            alert("No se ha Cargado la impresora de Tickets!");
    }
}

// funcion para buscar y Cargar la impresora al cargar la pagina
function monitorFinding() {
	//var applet = document.jzebra;
	if (applet != null) {
	   if (!applet.isDoneFinding()) {
	      window.setTimeout('monitorFinding()', 100);
	   }else {
	      var printer = applet.getPrinter();
	      if(printer==null){
	    	  alert("Impresora no Encontrada");
	      }
	   }
	}else{
        alert("No se ha Cargado la impresora de Tickets!");
        }
 }
    
    
    
    
// funcion para Completar con Ceros a la Izquierda de una Cadena
function   completaCerosIzquierda(cadena, longitud) {
	var strPivote = '';
	var i=0;	
	var longitudCadena=cadena.toString().length;
	var cadenaString=cadena.toString();
	
	for ( i = longitudCadena; i < longitud; i++) {
		strPivote = strPivote + '0';
	}
	
	return strPivote +cadenaString;
}
	

// funcion que alinea un dato en base a otro dato
function alinearDatoIzquierda(cadena, longitud){
   cadena = cadena.toString();
   longitudCadena=longitud.toString();
   length=longitudCadena.length;
   
   while(cadena.length < length)
	   cadena = " " + cadena;
   return cadena;
}

//funcion que alinea dato y agrega un prefijo
function alinearDato(cadena, longitud, prefijo){
 cadena=prefijo+cadena;
   cadena = cadena.toString(); 

   while(cadena.length < longitud)
	   cadena = " "+cadena;
   return cadena;
}
//funcion que alinea dato
function soloAlinearDato(cadena, longitud){
   cadena = cadena.toString(); 

   while(cadena.length < longitud)
	   cadena = " "+cadena;
   return cadena;
}

 
 
//fucnion para gregar formato moneda a una cantidad recibiendo como parametro la cantidad y el prefijo
function cantidadFormatoMoneda(num,prefix)  {  
	num = Math.round(parseFloat(num)*Math.pow(10,2))/Math.pow(10,2) ; 
	prefix = prefix || '';  
	num += '';  
	var splitStr = num.split('.');  
	var splitLeft = splitStr[0];  
	var splitRight = splitStr.length > 1 ? '.' + splitStr[1] : '.00';  
	splitRight = splitRight + '00';  
	splitRight = splitRight.substr(0,3);  
	var regx = /(\d+)(\d{3})/;  
	while (regx.test(splitLeft)) {  
		splitLeft = splitLeft.replace(regx, '$1' + ',' + '$2');  
	}  
	return prefix + splitLeft + splitRight;  
} 


  //funcion que centrar una cadena
 function justificaCentro(cadenaOriginal,numeroCaracteres,caracterStr) {
	 var cadenaString=cadenaOriginal.toString();
	   if (cadenaString ==''){
		   return "";
	   }
	   if (numeroCaracteres <= cadenaString.length){
		   if(numeroCaracteres > 0){
			   return cadenaString.substring(0, numeroCaracteres);
		   }else{
				return '';  
		   }
	   }
	   var caracteresAgregar = numeroCaracteres - cadenaString.length; 
	   var caracteresIzq = caracteresAgregar /2;
	   var	caracteresDer = caracteresAgregar - caracteresIzq;					
	
	   return (repiteCaracterString(caracteresIzq, caracterStr) + 
			cadenaString + repiteCaracterString(caracteresDer, caracterStr));
}
   
function repiteCaracterString(repeticionEnt, caracterStr) {
	var cadenaFormada='';
	for ( var i = 0; i < repeticionEnt ; i++ )
		cadenaFormada=cadenaFormada+caracterStr;
	return cadenaFormada;
}

 function resta(valor1,valor2){
  	var resultado;
	valor1=valor1.replace(',','');
	valor2=valor2.replace(',','');
  	resultado=parseFloat(valor1)-parseFloat(valor2);
  	return resultado;
 }
 
function suma(valor1,valor2){
	var resultado;
	valor1=valor1.replace(',','');
	valor2=valor2.replace(',','');
	resultado=parseFloat(valor1) + parseFloat(valor2);
	  	
	return resultado;
}


// Gets the current url's path, such as http://site.com/example/dist/
function getPath() {
	var path = window.location.href;
    return path.substring(0, path.lastIndexOf("/")) + "/";
}


//Convierte Fecha
function convierteFechaNombre(fecha){
	 var fechaNombre='';
	 var nombreMes='';
	 var arreglo = fecha.split('-');
	 var anio= arreglo[0];
	 var mes=arreglo[1];
	 var dia=arreglo[2];
	
	 if(mes==01){
		 nombreMes='Enero';
	 }else if(mes == '02'){
			 nombreMes='Febrero';
		 
	 } else if(mes == '03'){
			 nombreMes='Marzo';
		 
	 } else if(mes == '04'){
			 nombreMes='Abril';
		 
	 }else if(mes == '05'){
			 nombreMes='Mayo';
		 
	 } else if(mes == '06'){
			 nombreMes='Junio';
		 
	 } else if(mes == '07'){
			 nombreMes='Julio';
		 
	 } else if(mes == '08'){
			 nombreMes='Agosto';
		 
	 }else if(mes == '09'){
			 nombreMes='Septiembre';
		 
	 } else if(mes == '10'){
			 nombreMes='Octubre';
		 
	 } else if(mes == '11'){
			 nombreMes='Noviembre';
		 
	 } else{
		 nombreMes='Diciembre';
	 }
	
	fechaNombre=dia+ " de "+ nombreMes+ " del "+anio;
	return  fechaNombre;
}

//Funcion para mostrar los ultimos digitos de la CUENTA.
function reemplazaCuenta(cuenta){
	var cuentafinal='';
	var asteriscos="*******";
	var cuentaorigen=cuenta.substring(7,11);
	cuentafinal=asteriscos+cuentaorigen;
	return cuentafinal;
	
}

function setVariablesGlobales() {
	parametroBean = consultaParametrosSession();
	telefono = parametroBean.telefonoLocal;
	telefonoInt = parametroBean.telefonoInterior;
	sucursal = parametroBean.nombreSucursal;
	rfcInstitucion = parametroBean.rfcRepresentante;
	fecha = parametroBean.fechaSucursal;
	fechaHora = fecha + " " + hora();
	caja = parametroBean.cajaID;
	claveUsuario = parametroBean.claveUsuario;
	nombreInstitucion = parametroBean.nombreInstitucion;
	direccion = parametroBean.dirFiscal;
	rfcInstitucion = parametroBean.rfcInst;
	municipioEstado = parametroBean.edoMunSucursal;
	impresoraTicket = parametroBean.impTicket;
	direccionSucursal = parametroBean.edoMunSucursal;
	imprimeSaldoCredito = parametroBean.impSaldoCred;
	rutaImpTicket = parametroBean.recursoTicketVent;
}