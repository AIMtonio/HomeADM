package sms.servicio;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.StringTokenizer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import sms.bean.SMSCondiciCargaBean;
import sms.bean.SMSEnvioMensajeBean;
import sms.bean.SMSIngresosOpsBean;
import sms.dao.SMSEnvioMensajeDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;

import au.com.bytecode.opencsv.*;
 
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

import java.io.FileInputStream;

import cliente.servicio.ClienteServicio;
	
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDataFormatter;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;

import com.csvreader.CsvReader;

public class SMSEnvioMensajeServicio extends BaseServicio {

	// ---------Variables-------------------------
	SMSEnvioMensajeDAO smsEnvioMensajeDAO = null;
	ParametrosSMSServicio parametrosSMSServicio=null;
	SMSEnvioMensajeServicio smsEnvioMensajeServicio =null;
	SMSCondiciCargaServicio smsCondiciCargaServicio = null;
	ClienteServicio clienteServicio=null;
	public static interface Enum_Lis_Msj {
		int principal 	= 1;
	}

	public static interface Enum_Tra_Msj {
		int alta 		= 1;
		int altaMasivo 	= 2;
		int cancela 	= 3;
		int altaWS		= 4;
	}	

	public static interface Enum_Con_Msj {
		int principal 	= 1;
		int foranea		= 2;
	}

	public SMSEnvioMensajeServicio() {
		super();
	}
	public static interface Enum_TipoCon {
		int individual 	= 1;
		int masivo		= 2;
	}
	
	
	// Transacciones
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, final SMSEnvioMensajeBean smsEnvioMensajeBean, 
			final SMSCondiciCargaBean smsCondiciCargaBean, final String listaFechas, final String numTransaccion) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_Msj.alta:
				mensaje=leePlantilla(smsEnvioMensajeBean,tipoTransaccion );
			break;
			case Enum_Tra_Msj.altaMasivo:
				mensaje = smsCondiciCargaServicio.grabaTransaccion(tipoTransaccion, smsCondiciCargaBean, numTransaccion);
				//mensaje = leeArchivo(smsEnvioMensajeBean, listaFechas);
				mensaje = leerArchivoCSV(smsEnvioMensajeBean, smsCondiciCargaBean,listaFechas);
			break;
			case Enum_Tra_Msj.cancela:
				mensaje = cancelaEnvioSMS(tipoTransaccion, smsEnvioMensajeBean);
			break;

		}
		return mensaje;
	}
	
	//Alta de Envio de SMS
	public MensajeTransaccionBean altaSmsEnvio(int tipoTransaccion, SMSEnvioMensajeBean smsEnvioMensajeBean) {
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case Enum_Tra_Msj.alta:
				mensaje = smsEnvioMensajeDAO.altaSmsEnvio(tipoTransaccion, smsEnvioMensajeBean);
			break;
			case Enum_Tra_Msj.altaWS:
				mensaje = smsEnvioMensajeDAO.altaSmsEnvioWS(tipoTransaccion, smsEnvioMensajeBean);
			break;
		}
		return mensaje;
	}
	
	
	// Cancelacion de envio de sms
		public MensajeTransaccionBean cancelaEnvioSMS(int tipoTransaccion, SMSEnvioMensajeBean smsEnvioMensajeBean){
			MensajeTransaccionBean mensaje = null;
			
			mensaje = smsEnvioMensajeDAO.cancelaEnvioSMS(smsEnvioMensajeBean, Constantes.ENTERO_CERO);
			return mensaje;
		}

		//Funcion para leer el archivo csv 
		public List readCSVFile(String fileName) {
			CSVReader reader = null;
			List content = null;
			try {
				reader = new CSVReader(new FileReader(fileName));
				content = reader.readAll();
				reader.close();
			} catch (IOException e) {
				System.out.println("Error al leer el fichero!");
			}
			return content;
		}

		public String removeChar(String input) {
			StringBuilder sb = new StringBuilder();
			for (int i=0; i<input.length(); i++) {
				if ( ((int)input.charAt(i) >= 35 && (int)input.charAt(i) <= 93) || ((int)input.charAt(i) >= 97 && (int)input.charAt(i) <= 122) 
						|| ((int)input.charAt(i) == 32) || ((int)input.charAt(i) >= 160 && (int)input.charAt(i) <= 163) || ((int)input.charAt(i) == 181)
						|| ((int)input.charAt(i) == 130) || ((int)input.charAt(i) == 144) || ((int)input.charAt(i) == 214) || ((int)input.charAt(i) ==224)
						|| ((int)input.charAt(i) == 233) ){
					sb.append(input.charAt(i));
				}
			}//for i
			return sb.toString();
		}
			
		//Funcion para leer archivo CSV
		public MensajeTransaccionBean leerArchivoCSV(final SMSEnvioMensajeBean smsEnvioMensajeBean, final SMSCondiciCargaBean smsCondiciCargaBean, final String listaFechas){
			MensajeTransaccionBean mensaje = null;
			String fileName = smsEnvioMensajeBean.getColMensaje();
			List content = readCSVFile(fileName);
			
			File archivo = new File(fileName);
			FileReader fileReader = null;
			
			
			try{
				SMSEnvioMensajeBean smsEnvioMensaje= null;
				String mensajecajita="";
				int existe= 0;
				Integer RegErr = 0;
				Integer RegCor = 0;
				
				String mensajeEnviarBean = smsEnvioMensajeBean.getMsjenviar();
				String filas = "";
				String horaPeriodicidad ="";
				String msjenviar = "";
				String desFilas = "";
				String patron = "[0-9]{10}";
				Pattern p = Pattern.compile(patron);
				int i = 0;
				horaPeriodicidad = smsEnvioMensajeBean.getFechaProgEnvio();
				
				//Fichero debe contener campos en el siguiente orden, separados por pipes(|)
				//Numero de Cel
				//Mensaje
				//Num Cuenta
				//Num Cliente
				try {
					fileReader = new FileReader(archivo);
				} catch (FileNotFoundException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				CsvReader csvReader = new CsvReader(fileReader,'|');

				//Leemos los encabezados
				String[] parametros = null;
				try {
					if (csvReader.readHeaders()) {
					parametros = csvReader.getHeaders(); //parametros tendra los valores parametro[0] = nombre, parametro[1] = ciudad
					}
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				try{
					while(csvReader.readRecord()){ //Mientras se encuentren resultados
				    //while((row = reader.readNext()) != null) {
							smsEnvioMensaje= null;
							String celda1 = csvReader.get(0);
							String celda2 = csvReader.get(1);
							if(celda1 != null){
								//Validar el formato del telefono que sea de 10 digitos
								String cuentaID = "";
								String clienteID = "";
								String celda3;
								String celda4;
								celda1 = removeChar(celda1);
								celda2 = removeChar(celda2);
								try{
									if (csvReader.get(2) != null && (csvReader.get(2).length() != 0 ) ) {
										 celda3 = csvReader.get(2);
										 celda3 = removeChar(celda3);
										cuentaID = celda3;
									}
									if (csvReader.get(3) != null && (csvReader.get(3).length() != 0 )){
										celda4 = csvReader.get(3);
										celda4 = removeChar(celda4);
										clienteID = celda4;
									}
								}catch(ArrayIndexOutOfBoundsException e){
									cuentaID = " ";
									clienteID = " ";
								}
								
								Matcher matcher = p.matcher(celda1);
								if(matcher.matches()){
									smsEnvioMensajeBean.setReceptor(celda1);
									smsEnvioMensajeBean.setCuentaAsociada(cuentaID);
									smsEnvioMensajeBean.setClienteID(clienteID);
									if(celda2 != null ){
										msjenviar= celda2;
										// -------------------------------------------MENSAJE DE LA CELDA--------------------------
										if (mensajeEnviarBean.isEmpty()){
											if(! msjenviar.isEmpty()){
												existe= msjenviar.lastIndexOf('&');	
												//-------------------------------------------NO TRAE PLATILLA---------------------------------	
												if(existe == -1){
													smsEnvioMensajeBean.setMsjenviar(msjenviar);//-------
													if (listaFechas.isEmpty()){
														
														mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);
														if(mensaje.getNumero()==0){
															RegCor++;
														}else{
															RegErr++;
														}
													}else{
														StringTokenizer tokensBean = new StringTokenizer(listaFechas, "]");
														String stringCampos;
														String tokensCampos[];
														while (tokensBean.hasMoreTokens()){
															stringCampos = tokensBean.nextToken();
															tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
															smsEnvioMensajeBean.setFechaProgEnvio(tokensCampos[0] + " " +horaPeriodicidad);
															mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);
														}
														if(mensaje.getNumero()==0){
															RegCor++;
														}else{
															RegErr++;
														}
													}
												}else{
													//---------------------------------TRAE PLATILLA-----------------------------------------				
													smsEnvioMensajeBean.setMsjenviar(msjenviar);
													smsEnvioMensaje= smsEnvioMensajeDAO.generaMensaje(smsEnvioMensajeBean,Enum_TipoCon.masivo);	
													smsEnvioMensajeBean.setMsjenviar(smsEnvioMensaje.getMsjgenerado());
													//--------------------------------TODOS LOS NUMEROS EXISTEN-------------------------------
													if(smsEnvioMensaje.getEncontrado().equals("0") ){
														if (listaFechas.isEmpty()){
															mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);
															if(mensaje.getNumero()==0){
																RegCor++;
															}else{
																RegErr++;
															}
														}else{
															StringTokenizer tokensBean = new StringTokenizer(listaFechas, "]");
															String stringCampos;
															String tokensCampos[];
															while (tokensBean.hasMoreTokens()){
																stringCampos = tokensBean.nextToken();
																tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
																smsEnvioMensajeBean.setFechaProgEnvio(tokensCampos[0] + " " +horaPeriodicidad);
																mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);												
															}
															if(mensaje.getNumero()==0){
																RegCor++;
															}else{
																RegErr++;
															}
														}
														//----------------------------- HUBO NUMEROS QUE NO SE ENCONTRARON-----------------------				
													}else{
														//------------------------------PARAMETRIZADO SI ENVIAR----------------------------------
													try{
														if(smsEnvioMensaje.getEnviar().equals("S")){
															if (listaFechas.isEmpty()){
																mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);
															}else{									
																StringTokenizer tokensBean = new StringTokenizer(listaFechas, "]");
																String stringCampos;
																String tokensCampos[];
																while (tokensBean.hasMoreTokens()){
																	stringCampos = tokensBean.nextToken();
																	tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
																	smsEnvioMensajeBean.setFechaProgEnvio(tokensCampos[0] + " " +horaPeriodicidad);
																	mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);												
																}
															}
															//-----------------------------PARAMETRIZADO NO ENVIAR-----------------------------------
														}else{
															RegErr++;												
															if (RegErr != 12)
																filas = filas + " ( Plantilla no existente para el número teléfonico) " ;
															else
																filas = filas + "..." ;
															if(i==(content.size()-1)&& RegCor==0 ){
																desFilas = " Fila(s): "+ filas;
																mensaje=new MensajeTransaccionBean();
																mensaje.setDescripcion(" Registros Correctos: "+RegCor +
																					"  Registros Erroneos:"+ RegErr +
																					desFilas );		
																return mensaje;													
															}
														}
													}catch(NullPointerException e){ 
														mensaje.setDescripcion(" Registros Correctos: "+RegCor +
																"  Registros Erroneos:"+ RegErr +
																	desFilas );
														}
													}// no se encontraron

												}
											}
										}else{
											//----------------------------------------------------MENSAJE CAJITA-------------------------
											mensajecajita=mensajeEnviarBean;																	
											existe= mensajecajita.lastIndexOf('&');		
											//--------------------------------------------------NO TRAE PLATILLA-------------------------
											if(existe == -1){					
												smsEnvioMensajeBean.setMsjenviar(msjenviar);
												if (listaFechas.isEmpty()){
										
													mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);
													if(mensaje.getNumero()==0){
														RegCor++;
													}else{
														RegErr++;
													}
												}else{
													StringTokenizer tokensBean = new StringTokenizer(listaFechas, "]");
													String stringCampos;
													String tokensCampos[];
													while (tokensBean.hasMoreTokens()){
														stringCampos = tokensBean.nextToken();
														tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
														smsEnvioMensajeBean.setFechaProgEnvio(tokensCampos[0] + " " +horaPeriodicidad);
														mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);
													}
													if(mensaje.getNumero()==0){
														RegCor++;
													}else{
														RegErr++;
													}
												}
												//------------------------------------------------TRAE PLATILLA----------------------------------
											}else{									
												smsEnvioMensajeBean.setMsjenviar(mensajeEnviarBean);
												smsEnvioMensaje= smsEnvioMensajeDAO.generaMensaje(smsEnvioMensajeBean,Enum_TipoCon.masivo);	
												smsEnvioMensajeBean.setMsjenviar(smsEnvioMensaje.getMsjgenerado());
												//----------------------------------------------TODOS LOS NUEMEROS SE ENCONTRARON---------------
												if(smsEnvioMensaje.getEncontrado().equals("0")){																									
													if (listaFechas.isEmpty()){
														mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);
														if(mensaje.getNumero()==0){
															RegCor++;
														}else{
															RegErr++;
														}
													}else{		
														StringTokenizer tokensBean = new StringTokenizer(listaFechas, "]");
														String stringCampos;
														String tokensCampos[];
														while (tokensBean.hasMoreTokens()){
															stringCampos = tokensBean.nextToken();
															tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
															smsEnvioMensajeBean.setFechaProgEnvio(tokensCampos[0] + " " +horaPeriodicidad);
															mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);												
														}
														if(mensaje.getNumero()==0){
															RegCor++;
														}else{
															RegErr++;
														}
													}
													//---------------------------------------------NO SE ENCONTRO EL NUMERO-----------------------
												}else{
													//--------------------------------------------PARAMETRIZADO ENVIAR--------------------------
													if(smsEnvioMensaje.getEnviar().equals("S")){
														smsEnvioMensajeBean.setMsjenviar(smsEnvioMensaje.getMsjgenerado());
														if (listaFechas.isEmpty()){
															mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);
															if(mensaje.getNumero()==0){
																RegCor++;
															}else{
																RegErr++;
															}
														}else{
															StringTokenizer tokensBean = new StringTokenizer(listaFechas, "]");
															String stringCampos;
															String tokensCampos[];
															while (tokensBean.hasMoreTokens()){
																stringCampos = tokensBean.nextToken();
																tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
																smsEnvioMensajeBean.setFechaProgEnvio(tokensCampos[0] + " " +horaPeriodicidad);
																mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);												
															}
															if(mensaje.getNumero()==0){
																RegCor++;
															}else{
																RegErr++;
															}
														}
														//-----------------------------------------PARAMETRIZADO NO ENVIAR---------------------------------
													}else{
													try{
														RegErr++;
														if (RegErr != 12)
															filas = filas + " (Plantilla no existente para el número teléfonico) " ;
														else
															filas = filas + "..." ;
														if(i==(content.size()-1)&& RegCor==0 ){
															desFilas = " Fila(s): "+ filas;
															mensaje=new MensajeTransaccionBean();
															mensaje.setDescripcion( 
																				" Registros Correctos: "+RegCor +
																				"  Registros Erroneos:"+ RegErr +
																				desFilas );	
															return mensaje;
														}
													}catch(NullPointerException e){
														mensaje.setDescripcion(" Registros Correctos: "+RegCor +
															"  Registros Erroneos:"+ RegErr +
															desFilas );
													}
													}
												}
											}	
										}
									}else{//si no hay mensaje 
										if (!mensajeEnviarBean.isEmpty()){
											mensajecajita = mensajeEnviarBean;									
											existe= mensajecajita.lastIndexOf('&');
											//-------------------------------------NO TRAE PLATILLA----------------------------------------
											if(existe == -1){																				
												if (listaFechas.isEmpty()){
													mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);
													if(mensaje.getNumero()==0){
														RegCor++;
													}else{
														RegErr++;
													}
												}else{	
													StringTokenizer tokensBean = new StringTokenizer(listaFechas, "]");
													String stringCampos;
													String tokensCampos[];
													while (tokensBean.hasMoreTokens()){
														stringCampos = tokensBean.nextToken();
														tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
														smsEnvioMensajeBean.setFechaProgEnvio(tokensCampos[0] + " " +horaPeriodicidad);
														mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);												
													}
													if(mensaje.getNumero()==0){
														RegCor++;
													}else{
														RegErr++;
													}
												}
											}
											//-------------------------------------TRAE PLATILLA------------------------------------------
											else{
												smsEnvioMensajeBean.setMsjenviar(mensajeEnviarBean);
												smsEnvioMensaje= smsEnvioMensajeDAO.generaMensaje(smsEnvioMensajeBean,Enum_TipoCon.masivo);
												smsEnvioMensajeBean.setMsjenviar(smsEnvioMensaje.getMsjgenerado());
												//-----------------------------------SE ENCONTRO EL NUMERO---------------------------------
												if(smsEnvioMensaje.getEncontrado().equals("0")){
													if (listaFechas.isEmpty()){
														mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);
														if(mensaje.getNumero()==0){
															RegCor++;
														}else{
															RegErr++;
														}
													}else{
														StringTokenizer tokensBean = new StringTokenizer(listaFechas, "]");
														String stringCampos;
														String tokensCampos[];
														while (tokensBean.hasMoreTokens()){
															stringCampos = tokensBean.nextToken();
															tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
															smsEnvioMensajeBean.setFechaProgEnvio(tokensCampos[0] + " " +horaPeriodicidad);
															mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);
														}
														if(mensaje.getNumero()==0){
															RegCor++;
														}else{
															RegErr++;
														}
													}
													//----------------------------------------------NO SE ENCONTRO EL NUMERO---------------------
												}else{
													//--------------------------------------------PARAMETRIZADO ENVIAR------------------------------
													if(smsEnvioMensaje.getEnviar().equals("S")){
														if (listaFechas.isEmpty()){
															mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);
															if(mensaje.getNumero()==0){
																RegCor++;
															}else{
																RegErr++;
															}
														}else{		
															StringTokenizer tokensBean = new StringTokenizer(listaFechas, "]");
															String stringCampos;
															String tokensCampos[];
															while (tokensBean.hasMoreTokens()){
																stringCampos = tokensBean.nextToken();
																tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
																smsEnvioMensajeBean.setFechaProgEnvio(tokensCampos[0] + " " +horaPeriodicidad);
																mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);												
															}
															if(mensaje.getNumero()==0){
																RegCor++;
															}else{
																RegErr++;
															}
														}
														//---------------------------------------PARAMETRIZADO NO ENVIAR------------------------------
													}else{
													try{
														RegErr++;											
														if (RegErr != 12)
															filas = filas + " ( Plantilla no existente para el número teléfonico) " ;
														else
															filas = filas + "..." ;
														if(i==(content.size()-1) && RegCor==0){  
															desFilas = " Fila(s): "+ filas;
															mensaje=new MensajeTransaccionBean();
															mensaje.setDescripcion(" Registros Correctos: "+RegCor +
																				"  Registros Erroneos:"+ RegErr +
																				desFilas );
															return mensaje;
														}
													}catch(NullPointerException e){
														mensaje.setDescripcion(" Registros Correctos: "+RegCor +
																"  Registros Erroneos:"+ RegErr +
																desFilas );
													}
													}
												}
											}// plantilla
											//--------------------------------NO HAY MENSAJE NI EN CAJITA NI EL CELDA
										}else{
											mensaje = new MensajeTransaccionBean();
											mensaje.setNumero(0);
											mensaje.setDescripcion("No existe ningun mensaje.");
											mensaje.setNombreControl("campaniaID");
							
											return mensaje;									
										}
									}						
								}else{ // el telefono no cuenta con el formato
									RegErr++;
									if (RegErr != 12)
										filas = filas + " (Formato teléfonico incorrecto), " ;
									else
										filas = filas + "..." ;
								}
							}else{
								mensaje = new MensajeTransaccionBean();
								mensaje.setNumero(0);
								mensaje.setDescripcion("Asegurese de seleccionar el archivo correcto.");
								mensaje.setNombreControl("campaniaID");	
								return mensaje;
							}
							i++;
						
						if (RegErr != 0 ){
							desFilas = " Fila(s): "+ filas;
						}
						mensaje.setDescripcion(mensaje.getDescripcion()+ 
							" Registros Correctos: "+RegCor +
							"  Registros Erroneos:"+ RegErr +
							desFilas );				
					}
				}catch(NullPointerException e){
					mensaje = new MensajeTransaccionBean();
					mensaje.setNumero(0);
					mensaje.setDescripcion(
							desFilas );
				}
			}catch(Exception e){
				e.printStackTrace();
			}
			return mensaje;
					
		}
		
	//Lee el Mensaje  e identifica si contiene plantilla en envio de mensajes individuales
		public MensajeTransaccionBean leePlantilla(final SMSEnvioMensajeBean smsEnvioMensajeBean ,int tipoTransaccion){
			MensajeTransaccionBean mensaje = null;
			SMSEnvioMensajeBean smsEnvioMensaje= null;
			
			String mensajecajita="";
			int existe= 0;		
			String mensajeEnviarBean = smsEnvioMensajeBean.getMsjenviar();
																			
			mensajecajita=mensajeEnviarBean;																	
			existe= mensajecajita.lastIndexOf('&');										
			if(existe == -1){																						
				
				mensaje = smsEnvioMensajeDAO.altaSmsEnvio(tipoTransaccion, smsEnvioMensajeBean);			
			}else{				
				smsEnvioMensajeBean.setMsjenviar(mensajeEnviarBean);
				smsEnvioMensaje= smsEnvioMensajeDAO.generaMensaje(smsEnvioMensajeBean,Enum_TipoCon.masivo);	

				smsEnvioMensajeBean.setMsjenviar(smsEnvioMensaje.getMsjgenerado());
				
					if(smsEnvioMensaje.getEncontrado().equals("0")  ){
						mensaje = smsEnvioMensajeDAO.altaSmsEnvio(tipoTransaccion, smsEnvioMensajeBean);
					}else{
						if(smsEnvioMensaje.getEnviar().equals("S")){
							mensaje = smsEnvioMensajeDAO.altaSmsEnvio(tipoTransaccion, smsEnvioMensajeBean);
						}else{
							mensaje=new MensajeTransaccionBean();
							mensaje.setNumero(06);
							mensaje.setDescripcion("Mensaje no enviado, Plantilla no existente para el número teléfonico");
							mensaje.setNombreControl("campaniaID");
						}
					}
			}
			return mensaje;		
		}

		
			
	//Funcion para leer el archivo xls 
	public ArrayList<HSSFRow> readExcelFile(String fileName, int filaInicio, int numHoja) {
		ArrayList<HSSFRow> list = new ArrayList<HSSFRow>();
		try {
			POIFSFileSystem fs = new POIFSFileSystem(new FileInputStream(fileName));
			HSSFWorkbook libro = new HSSFWorkbook(fs);
			
			HSSFSheet hoja = libro.getSheetAt(numHoja);
			HSSFRow fila;
			Iterator iterator = hoja.rowIterator();
			while (iterator.hasNext()) {
				fila = hoja.getRow(filaInicio);
				if (fila != null) {
					list.add(fila);
				} else {}
				iterator.next();
				filaInicio++;
			}
			
			
			
			
		} catch (IOException e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en leer archivo de excel", e);
		}
		return list;
	}
		
	//Lee el archivo xls para obtener numeros de destinatario
	public MensajeTransaccionBean leeArchivo(final SMSEnvioMensajeBean smsEnvioMensajeBean, final SMSCondiciCargaBean smsCondiciCargaBean, final String listaFechas){
		MensajeTransaccionBean mensaje = null;
		SMSEnvioMensajeBean smsEnvioMensaje= null;
		
		String mensajecajita="";
		int existe= 0;
		String archivoNombre = "";
		Integer RegErr = 0;
		Integer RegCor = 0;
		String filas = "";
		String encontrado="";
		archivoNombre = smsEnvioMensajeBean.getColMensaje();
		ArrayList<HSSFRow> listafilas = new ArrayList<HSSFRow>();
		String mensajeEnviarBean = smsEnvioMensajeBean.getMsjenviar();
		
		listafilas = readExcelFile(archivoNombre, 1, 0);//  fila 1, hoja 0
		Double telefono;
		String horaPeriodicidad ="";
		String msjenviar = "";
		String desFilas = "";
		Double cuentaAsoc ;
		Double cliente ;
		String patron = "[0-9]{10}";
		Pattern p = Pattern.compile(patron);
		horaPeriodicidad = smsEnvioMensajeBean.getFechaProgEnvio();
		
	
		
		
		
		
		for (int i = 0; i < listafilas.size(); i++) {
			 smsEnvioMensaje= null;
			HSSFCell celda1 = listafilas.get(i).getCell(0);
			HSSFCell celda2 = listafilas.get(i).getCell(1);
			try{
				if(celda1 != null){
					if ((celda1.getCellType() == HSSFCell.CELL_TYPE_NUMERIC)){
						telefono = celda1.getNumericCellValue();
						
						HSSFDataFormatter formatter = new HSSFDataFormatter(); 
						String destina = formatter.formatRawCellContents(telefono,0,"##########");
						String cuentaID = "";
						String clienteID = "";
						if (listafilas.get(i).getCell(2) != null ){
							HSSFCell celda3 = listafilas.get(i).getCell(2);
							cuentaAsoc = celda3.getNumericCellValue();
							cuentaID = formatter.formatRawCellContents(cuentaAsoc,0,"#");
						}
						if (listafilas.get(i).getCell(3) != null){
							HSSFCell celda4 = listafilas.get(i).getCell(3);
							cliente = celda4.getNumericCellValue();
							clienteID = formatter.formatRawCellContents(cliente,0,"#");
						}

						Matcher matcher = p.matcher(destina);
						if(matcher.matches()){
							//RegCor++;
							smsEnvioMensajeBean.setReceptor(destina);
							smsEnvioMensajeBean.setCuentaAsociada(cuentaID);
							smsEnvioMensajeBean.setClienteID(clienteID);
							if(celda2 != null ){
							msjenviar= celda2.getStringCellValue();
							// -------------------------------------------MENSAJE DE LA CELDA--------------------------
							if (mensajeEnviarBean.isEmpty()){									
								if(! msjenviar.isEmpty()){
									/**/existe= msjenviar.lastIndexOf('&');	
							//-------------------------------------------NO TRAE PLATILLA---------------------------------	
									if(existe == -1){	/**/
										smsEnvioMensajeBean.setMsjenviar(msjenviar);//-------
										if (listaFechas.isEmpty()){
											RegCor++;
											mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);
										}else{
											RegCor++;
											StringTokenizer tokensBean = new StringTokenizer(listaFechas, "]");
											String stringCampos;
											String tokensCampos[];
											while (tokensBean.hasMoreTokens()){
												
												stringCampos = tokensBean.nextToken();
												tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
												smsEnvioMensajeBean.setFechaProgEnvio(tokensCampos[0] + " " +horaPeriodicidad);
												mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);
											}
										}//--------
									/**/}else{	
							//---------------------------------TRAE PLATILLA-----------------------------------------				
										smsEnvioMensajeBean.setMsjenviar(msjenviar);
										smsEnvioMensaje= smsEnvioMensajeDAO.generaMensaje(smsEnvioMensajeBean,Enum_TipoCon.masivo);	
										smsEnvioMensajeBean.setMsjenviar(smsEnvioMensaje.getMsjgenerado());
							//--------------------------------TODOS LOS NUMEROS EXISTEN-------------------------------
										if(smsEnvioMensaje.getEncontrado().equals("0") ){
											if (listaFechas.isEmpty()){
												RegCor++;
												mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);
											}else{
												RegCor++;
												StringTokenizer tokensBean = new StringTokenizer(listaFechas, "]");
												String stringCampos;
												String tokensCampos[];
												while (tokensBean.hasMoreTokens()){
													stringCampos = tokensBean.nextToken();
													tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
													smsEnvioMensajeBean.setFechaProgEnvio(tokensCampos[0] + " " +horaPeriodicidad);
													mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);												
												}
											}
							//----------------------------- HUBO NUMEROS QUE NO SE ENCONTRARON-----------------------				
										}else{
							//------------------------------PARAMETRIZADO SI ENVIAR----------------------------------
											if(smsEnvioMensaje.getEnviar().equals("S")){
												if (listaFechas.isEmpty()){
													mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);
												}else{									
													StringTokenizer tokensBean = new StringTokenizer(listaFechas, "]");
													String stringCampos;
													String tokensCampos[];
													while (tokensBean.hasMoreTokens()){
														stringCampos = tokensBean.nextToken();
														tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
														smsEnvioMensajeBean.setFechaProgEnvio(tokensCampos[0] + " " +horaPeriodicidad);
														mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);												
													}
												}
							//-----------------------------PARAMETRIZADO NO ENVIAR-----------------------------------
											}else{

												RegErr++;												
												if (RegErr != 12)
													filas = filas + (celda1.getRowIndex()+1) +" ( Plantilla no existente para el número teléfonico) " ;
												else
													filas = filas + "..." ;
												if(i==(listafilas.size()-1)&& RegCor==0 ){
													desFilas = " Fila(s): "+ filas;
													mensaje=new MensajeTransaccionBean();
													mensaje.setDescripcion(" Registros Correctos: "+RegCor +
																		"  Registros Erroneos:"+ RegErr +
																		desFilas );		
													return mensaje;
													
												}
											}
											
											
										}// no se encontraron
										
									}/**/
								}																
							} else{	
							//----------------------------------------------------MENSAJE CAJITA-------------------------
								mensajecajita=mensajeEnviarBean;																	
								existe= mensajecajita.lastIndexOf('&');		
							//--------------------------------------------------NO TRAE PLATILLA-------------------------
								if(existe == -1){					
									smsEnvioMensajeBean.setMsjenviar(msjenviar);
									if (listaFechas.isEmpty()){
										RegCor++;
										mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);
									}else{
										RegCor++;
										StringTokenizer tokensBean = new StringTokenizer(listaFechas, "]");
										String stringCampos;
										String tokensCampos[];
										while (tokensBean.hasMoreTokens()){
											stringCampos = tokensBean.nextToken();
											tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
											smsEnvioMensajeBean.setFechaProgEnvio(tokensCampos[0] + " " +horaPeriodicidad);
											mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);
										}
									}
							//------------------------------------------------TRAE PLATILLA----------------------------------
								}else{
									
									smsEnvioMensajeBean.setMsjenviar(mensajeEnviarBean);
									smsEnvioMensaje= smsEnvioMensajeDAO.generaMensaje(smsEnvioMensajeBean,Enum_TipoCon.masivo);	
									smsEnvioMensajeBean.setMsjenviar(smsEnvioMensaje.getMsjgenerado());
							//----------------------------------------------TODOS LOS NUEMEROS SE ENCONTRARON---------------
									if(smsEnvioMensaje.getEncontrado().equals("0")){																									
										if (listaFechas.isEmpty()){
											RegCor++;
											mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);
										}else{		
											RegCor++;
											StringTokenizer tokensBean = new StringTokenizer(listaFechas, "]");
											String stringCampos;
											String tokensCampos[];
											while (tokensBean.hasMoreTokens()){
												stringCampos = tokensBean.nextToken();
												tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
												smsEnvioMensajeBean.setFechaProgEnvio(tokensCampos[0] + " " +horaPeriodicidad);
												mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);												
											}
										}
							//---------------------------------------------NO SE ENCONTRO EL NUMERO-----------------------
									}else{
							//--------------------------------------------PARAMETRIZADO ENVIAR--------------------------
										if(smsEnvioMensaje.getEnviar().equals("S")){
											smsEnvioMensajeBean.setMsjenviar(smsEnvioMensaje.getMsjgenerado());
											
											if (listaFechas.isEmpty()){
												RegCor++;
												mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);
											}else{
												RegCor++;
												StringTokenizer tokensBean = new StringTokenizer(listaFechas, "]");
												String stringCampos;
												String tokensCampos[];
												while (tokensBean.hasMoreTokens()){
													stringCampos = tokensBean.nextToken();
													tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
													smsEnvioMensajeBean.setFechaProgEnvio(tokensCampos[0] + " " +horaPeriodicidad);
													mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);												
												}
											}
						//-----------------------------------------PARAMETRIZADO NO ENVIAR---------------------------------
										}else{

											RegErr++;
											
											if (RegErr != 12)
												filas = filas + (celda1.getRowIndex()+1) +" (Plantilla no existente para el número teléfonico) " ;
											else
												filas = filas + "..." ;
											if(i==(listafilas.size()-1)&& RegCor==0 ){
												desFilas = " Fila(s): "+ filas;
												mensaje=new MensajeTransaccionBean();
												mensaje.setDescripcion( 
																	" Registros Correctos: "+RegCor +
																	"  Registros Erroneos:"+ RegErr +
																	desFilas );	
												return mensaje;
												
											}
																																										
										}
									}
																																																						
								}
							}						
					//-------------------------------------MENSAJE CAJITA------------------------------------------
						}else{//si no hay mensaje 
							
							if (!mensajeEnviarBean.isEmpty()){
							 mensajecajita = mensajeEnviarBean;									
							existe= mensajecajita.lastIndexOf('&');
					//-------------------------------------NO TRAE PLATILLA----------------------------------------
								if(existe == -1){																				
									 if (listaFechas.isEmpty()){
										 RegCor++;
											mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);
									}else{	
										RegCor++;
										StringTokenizer tokensBean = new StringTokenizer(listaFechas, "]");
										String stringCampos;
										String tokensCampos[];
										while (tokensBean.hasMoreTokens()){
												stringCampos = tokensBean.nextToken();
												tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
												smsEnvioMensajeBean.setFechaProgEnvio(tokensCampos[0] + " " +horaPeriodicidad);
												mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);												
										}
									}								 									
								}
					//-------------------------------------TRAE PLATILLA------------------------------------------
								else{
									
									smsEnvioMensajeBean.setMsjenviar(mensajeEnviarBean);
									smsEnvioMensaje= smsEnvioMensajeDAO.generaMensaje(smsEnvioMensajeBean,Enum_TipoCon.masivo);											
									smsEnvioMensajeBean.setMsjenviar(smsEnvioMensaje.getMsjgenerado());
					//-----------------------------------SE ENCONTRO EL NUMERO---------------------------------
									if(smsEnvioMensaje.getEncontrado().equals("0")){
										 if (listaFechas.isEmpty()){
											 RegCor++;
												mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);
										 }else{		
											 RegCor++;
											StringTokenizer tokensBean = new StringTokenizer(listaFechas, "]");
											String stringCampos;
											String tokensCampos[];
											while (tokensBean.hasMoreTokens()){
													stringCampos = tokensBean.nextToken();
													tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
													smsEnvioMensajeBean.setFechaProgEnvio(tokensCampos[0] + " " +horaPeriodicidad);
													mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);												
											}
										 }
						//----------------------------------------------NO SE ENCONTRO EL NUMERO---------------------
									}else{
						//--------------------------------------------PARAMETRIZADO ENVIAR------------------------------
										if(smsEnvioMensaje.getEnviar().equals("S")){
											if (listaFechas.isEmpty()){
												 RegCor++;
													mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);
											 }else{		
												 RegCor++;
												StringTokenizer tokensBean = new StringTokenizer(listaFechas, "]");
												String stringCampos;
												String tokensCampos[];
												while (tokensBean.hasMoreTokens()){
														stringCampos = tokensBean.nextToken();
														tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
														smsEnvioMensajeBean.setFechaProgEnvio(tokensCampos[0] + " " +horaPeriodicidad);
														mensaje = smsEnvioMensajeDAO.altaMasivo(smsEnvioMensajeBean,smsCondiciCargaBean);												
												}
											 }	
							//---------------------------------------PARAMETRIZADO NO ENVIAR------------------------------
										}else{
											RegErr++;											
											if (RegErr != 12)
												filas = filas + (celda1.getRowIndex()+1) +" ( Plantilla no existente para el número teléfonico) " ;
											else
												filas = filas + "..." ;		
											if(i==(listafilas.size()-1) && RegCor==0){
												desFilas = " Fila(s): "+ filas;
												mensaje=new MensajeTransaccionBean();
												mensaje.setDescripcion(" Registros Correctos: "+RegCor +
																	"  Registros Erroneos:"+ RegErr +
																	desFilas );		
												return mensaje;
												
											}
											
										}
										
									}
								
								
								}// plantilla
					//--------------------------------NO HAY MENSAJE NI EN CAJITA NI EL CELDA
							}else{
								mensaje = new MensajeTransaccionBean();
								mensaje.setNumero(0);
								mensaje.setDescripcion("No existe ningun mensaje.");
								mensaje.setNombreControl("campaniaID");
				
								return mensaje;									
							}
						}						
								
					}else{ // el telefono no cuenta con el formato
						RegErr++;
						if (RegErr != 12)
							filas = filas + (celda1.getRowIndex()+1) +" (Formato teléfonico incorrecto), " ;
						else
							filas = filas + "..." ;
						}													
					}else{// no es  un numero
						RegErr++;
						if (RegErr != 12)
							filas = filas + (celda1.getRowIndex()+1) +" (No es un número), " ;
						else
							filas = filas + "..." ;					
					}
				}else{
					mensaje = new MensajeTransaccionBean();
					mensaje.setNumero(0);
					mensaje.setDescripcion("Asegurese de seleccionar el archivo correcto.");
					mensaje.setNombreControl("campaniaID");
	
					return mensaje;					
				}
			}catch(IllegalStateException ex){
				RegErr++;
				if (RegErr != 12)
					filas = filas + (celda1.getRowIndex()+1) +", " ;
				else
					filas = filas + "..." ;
			}						
		}// for
						
		if (RegErr != 0 ){
			desFilas = " Fila(s): "+ filas;
		}
		mensaje.setDescripcion(mensaje.getDescripcion()+ 
			" Registros Correctos: "+RegCor +
			"  Registros Erroneos:"+ RegErr +
			desFilas );
	return mensaje;
		
		
	}
	

	
	// ------------Getters y Setters--------------------
	public SMSEnvioMensajeDAO getSmsEnvioMensajeDAO() {
		return smsEnvioMensajeDAO;
	}

	public void setSmsEnvioMensajeDAO(SMSEnvioMensajeDAO smsEnvioMensajeDAO) {
		this.smsEnvioMensajeDAO = smsEnvioMensajeDAO;
	}

	public void setParametrosSMSServicio(ParametrosSMSServicio parametrosSMSServicio) {
		this.parametrosSMSServicio = parametrosSMSServicio;
	}

	public void setSmsEnvioMensajeServicio(
			SMSEnvioMensajeServicio smsEnvioMensajeServicio) {
		this.smsEnvioMensajeServicio = smsEnvioMensajeServicio;
	}

	public void setSmsCondiciCargaServicio(
			SMSCondiciCargaServicio smsCondiciCargaServicio) {
		this.smsCondiciCargaServicio = smsCondiciCargaServicio;
	}
	

}
