package soporte.dao;

import java.io.BufferedReader;
import java.io.FileReader;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import com.itextpdf.text.Utilities;

import activos.bean.ActivosBean;

import soporte.bean.CargosObjArchivosBean;
import soporte.bean.ResultadoCargaArchivosObjetadosBean;
import tesoreria.bean.ResultadoCargaArchivosTesoreriaBean;
import tesoreria.bean.TesoMovsArchConciliaBean;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class CargosObjArchivosDAO extends BaseDAO{
	String saltoLinea=" <br> ";
	private final static String salidaPantalla = "S";
	public CargosObjArchivosDAO() {
		super();
		// TODO Auto-generated constructor stub
	}

	public ResultadoCargaArchivosObjetadosBean cargaCargosObjetados(final CargosObjArchivosBean cargosObjArchivosBean){
		ResultadoCargaArchivosObjetadosBean resultado = new ResultadoCargaArchivosObjetadosBean();
		transaccionDAO.generaNumeroTransaccion();

		resultado = (ResultadoCargaArchivosObjetadosBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				//Declaracion de Variables
				ResultadoCargaArchivosObjetadosBean resultadoBean = new ResultadoCargaArchivosObjetadosBean();	// bean para manejo de errores y resultados
				List<CargosObjArchivosBean> listaCargosObj = null;		// lista de beans para obtener la lista de cargos Objetados.
				Iterator<CargosObjArchivosBean> iterList=null;		// iterador para el manejo de la lista
				CargosObjArchivosBean apuntador=null;					// apuntador para cada bean que devuelva la consulta de la lista
				BufferedReader bufferedReader=null;						// lee el archivo hasta el salto de linea
				String nombreOri	=cargosObjArchivosBean.getLayout();						// Se almacena el en nombre de la ruta de origen
				String tokens[]		=nombreOri.split("[.]");			// Arreglo para separar los el nombre del archivo con su extension
				String extension	="."+tokens[1];						// Se almacena el nombre de la extension
				String motivo		="";								// descripcion de los fallos
				String renglon		="";								// renglon actual de la iteracion
				int tamanoLista		=0;									// tamaño de la lista (listConcilia)
				int contador		=1;									// es el contador que representa las lineas de los registros
				int contadorerr		=1;									// contador de errores
				int exitos			=0;									// contador de exitos
				int fallidos		=0;									// contador de fallos
				float cant			=0;									// cantidad del monto de movimiento
				long transaccion	= 0;								// transaccion de la operacion actual, que seria de la carga de archivo
				boolean error		=true;								// bandera de error
				String motivoexcluido = "";								// motivo por la que se excluyen

				try{
					if(extension.equals(".csv")){
						listaCargosObj=leeArchivoCargosObjCsv(cargosObjArchivosBean.getLayout());
					}


					if(listaCargosObj!=null){
						iterList=listaCargosObj.iterator();
						if(extension.equals(".csv")){
							// si la lista no esta vacia quiere decir que se leyo correctamente el archivo
							transaccion = parametrosAuditoriaBean.getNumeroTransaccion();
								// while para recorrer el arreglo de beans que se creo al leer el archivo
							while(iterList.hasNext()){
							contador = contador+1;
							apuntador=(CargosObjArchivosBean) iterList.next();
							tamanoLista = apuntador.getTamanioListaCarga();

							if(apuntador.getError()!=null){

								if(apuntador.getError().equals("799")){
									fallidos = fallidos+1;
									motivo= apuntador.getDescripcionMov();
									resultadoBean.setNumero(799);
									resultadoBean.setDescripcion("Total Registros: "+tamanoLista+ saltoLinea+"Exitosos: 0"+saltoLinea+"Fallidos: "
												+tamanoLista + saltoLinea+"Motivo:"+motivo);
									throw new Exception(resultadoBean.getDescripcion());
								}
							}

							resultadoBean= altaCargosObj(cargosObjArchivosBean,apuntador, transaccion);
							if(resultadoBean.getNumero() != 0){
							resultadoBean.setNumero(999);
							throw new Exception(resultadoBean.getDescripcion());
							}else{
								resultadoBean.setNumero(0);
								resultadoBean.setDescripcion("Cargos Objetados en el Periodo Grabado Exitosamente.");
								resultadoBean.setNombreControl("agregar");
								resultadoBean.setConsecutivoInt("0");
							}
							}
						  }else{
								resultadoBean.setNumero(999);
								resultadoBean.setDescripcion("Error al Cargar, Asegurese de Seleccionar el Archivo Correcto. La extensión seleccionada debe ser 'txt','exp' o 'csv'");
								throw new Exception(resultadoBean.getDescripcion());
							}
					}else{
						resultadoBean.setNumero(999);
						resultadoBean.setDescripcion("Error al Cargar, Asegúrese de seleccionar el formato del archivo correctamente.");
						throw new Exception(resultadoBean.getDescripcion());
					}

				}catch(Exception e){
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en validacion de fecha de conciliacion", e);
					switch(resultadoBean.getNumero()){
					case 123:
						resultadoBean.setNumero(999);
						resultadoBean.setDescripcion("Error al Cargar, Asegurese de Seleccionar el Archivo Correcto. La extensión seleccionada debe ser 'csv'");
						resultadoBean.setNombreControl("Falló la Carga");

						break;
					default:
						resultadoBean.setNumero(999);
						resultadoBean.setDescripcion(resultadoBean.getDescripcion());
						resultadoBean.setNombreControl("Falló la Carga");

						break;
					}
					transaction.setRollbackOnly();
				}
				return resultadoBean;
			}
		});
		return resultado;
	}

	public List<CargosObjArchivosBean> leeArchivoCargosObjCsv(String nombreArchivo){
		// Orden de los datos:


		// Folio|Fecha|TipoInstrumento|Instrumento|Descripción|Cargo|Abono
		ArrayList<CargosObjArchivosBean> listaArchivoCargosObj = new ArrayList<CargosObjArchivosBean>();
		BufferedReader bufferedReader;
		String [] arreglo = null;
		CargosObjArchivosBean cargosObj;
		CargosObjArchivosBean obtenerError;

		String renglon;
		boolean fechaValida = true;
		int numeroLinea = 0;
		int tamEncabezado = 1;
		int numCamposEncabezado = 7;
		// encabezados
		String folio="";
		String fecha="";
		String tipoInstrumento="";
		String instrumento="";
		String descripcion="";
		double cargo=0;
		double abono=0;
		obtenerError = new CargosObjArchivosBean();


		try {

			try{
			bufferedReader = new BufferedReader(new FileReader(nombreArchivo));

			while ((renglon = bufferedReader.readLine())!= null && !renglon.trim().equals("")){
				numeroLinea +=1;


				if(numeroLinea>tamEncabezado){

					cargosObj = new CargosObjArchivosBean();
					arreglo = renglon.split("\\|");

					if(arreglo.length == numCamposEncabezado){

						folio = arreglo[0].trim();
						cargosObj.setFolio(folio);
						fecha =  arreglo[1].trim();
						tipoInstrumento=arreglo[2].trim();
						cargosObj.setTipoInstrumento(tipoInstrumento);
						instrumento= arreglo[3].trim();
						cargosObj.setInstrumentoID(instrumento);
						descripcion= arreglo[4].trim();
						cargosObj.setDescripcion(arreglo[4].trim());
							cargo = convCanPositiva(	arreglo[5].trim().replaceAll(",","").replaceAll("\\$", ""));

							abono = convCanPositiva(	arreglo[6].trim().replaceAll(",","").replaceAll("\\$", ""));
							try{	fechaValida = OperacionesFechas.validarFecha(fecha);
							}catch(Exception e){

								e.printStackTrace();
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en  la fecha de cargos objetados");
								fechaValida=false;
							}
							if(fechaValida){
									try{
										cargosObj.setFecha(fecha);

										if(cargosObj.getFolio().length() > 0 || !cargosObj.getFolio().equals("")){

										if(descripcion.length()<=200 && descripcion.length()>0){
											cargosObj.setDescripcion(descripcion);

												if(!arreglo[5].trim().isEmpty() || !arreglo[6].trim().isEmpty()){
													if(abono > 0 || cargo > 0 ){
														cargosObj.setMontoAbono(arreglo[6].trim().replaceAll(",","").replaceAll("\\$",""));
														cargosObj.setMontoCargo(arreglo[5].trim().replaceAll(",","").replaceAll("\\$",""));
													}
												else{

														cargosObj.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: El Monto es negativo o no coincide con el formato numérico en los campos cargo y abono.");
														cargosObj.setError("799");
													}


												}else{

													cargosObj.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: El Monto esta vacío en los campos cargo y abono.");
													cargosObj.setError("799");
												}

										}
										else if(descripcion.length()<=0){
											cargosObj.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: La Descripción está vacía.");
											cargosObj.setError("799");
										}else{
											cargosObj.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: La descripción sobrepasa el límite de 200 caracteres.");
											cargosObj.setError("799");
										}
										}else{cargosObj.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: El Folio está Vacío.");
										cargosObj.setError("799");}

									} catch (Exception e) {
										e.printStackTrace();
										loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en leer archivos Cargos Objetados", e);
									}

								}else{

									cargosObj.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: Valor Incorrecto para Fecha.");
									loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+cargosObj.getDescripcionMov());
									cargosObj.setError("799");
								}

				}
					else{
						cargosObj.setDescripcionMov(" Error al leer los Datos");
						cargosObj.setError("799");

					}
					listaArchivoCargosObj.add(cargosObj);
				}


			}

			if(arreglo.length-1 !=numCamposEncabezado-1 )
			{
				obtenerError.setDescripcionMov(" El Número de Columnas no corresponde con el Layout de Cargos Objetados.");
				obtenerError.setError("799");
				listaArchivoCargosObj.add(obtenerError);

			}

			bufferedReader.close();

			}catch (NullPointerException ex) {

				obtenerError.setDescripcionMov(" El Número de Columnas no corresponde con el Layout de Cargos Objetados.");
				obtenerError.setError("799");
				listaArchivoCargosObj.add(obtenerError);
				ex.printStackTrace();
			}

		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al leer archivos de CargosObj", e);
		}

				Iterator<CargosObjArchivosBean> iterList = null;
				iterList = listaArchivoCargosObj.iterator();
				int tamanioLista = numeroLinea-tamEncabezado;//es la ultima linea leida menos el tamaño del encabezado da el total de la lista
				if(tamanioLista<0){
					tamanioLista = 0;
				}
				while(iterList.hasNext()){
					iterList.next().setTamanioListaCarga(tamanioLista);
				}
		return listaArchivoCargosObj;
	}


public double convCanPositiva(String cantidad){
	double cantidadFloat=0;
	if (cantidad.isEmpty())return 0;

	try{
		cantidadFloat = Double.valueOf(cantidad);

	}catch(Exception e){
		e.printStackTrace();
		cantidadFloat=0;
	}
	return cantidadFloat;
}

public boolean validaNaturaMontos(String cantidad,String cantidad2){
	if(cantidad == null && cantidad2 == null)
	{
		cantidad = "0.0";
		cantidad2 = "0.0";
	}
	float cantidadFloat=0;
	float cantidadFloat2=0;

	boolean resul=true;
	try{
		if(cantidad.isEmpty()){
			cantidad = Constantes.STRING_CERO;
		}
		if(cantidad2.isEmpty()){
			cantidad2 = Constantes.STRING_CERO;
		}
		cantidadFloat = Float.parseFloat(cantidad);
		cantidadFloat2 = Float.parseFloat(cantidad2);
		if( cantidadFloat > 0.0 && cantidadFloat2 > 0.0){
			resul= false;
		}

	}catch(Exception e){
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en valida natural montos");
		resul= false;
	}
	return resul;
}



public ResultadoCargaArchivosObjetadosBean altaCargosObj(final CargosObjArchivosBean cargosObjBeanPantalla,final CargosObjArchivosBean cargosObjArchivosList,
			final long transaccion) {

	ResultadoCargaArchivosObjetadosBean mensaje = new ResultadoCargaArchivosObjetadosBean();

			mensaje = (ResultadoCargaArchivosObjetadosBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					ResultadoCargaArchivosObjetadosBean mensajeBean = new ResultadoCargaArchivosObjetadosBean();
					try {
						// Query con el Store Procedure
						mensajeBean = (ResultadoCargaArchivosObjetadosBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call CARGOSOBJETADOSALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?);"; // parametros salida y auditoria

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_Folio",cargosObjArchivosList.getFolio());

									sentenciaStore.setInt("Par_Periodo",Utileria.convierteEntero(cargosObjBeanPantalla.getPeriodo()));

									sentenciaStore.setString("Par_Fecha",Utileria.convierteFecha(cargosObjArchivosList.getFecha()));

									sentenciaStore.setString("Par_TipoInstrumento",cargosObjArchivosList.getTipoInstrumento());

									sentenciaStore.setLong("Par_InstrumentoID",Utileria.convierteLong(cargosObjArchivosList.getInstrumentoID()));

									sentenciaStore.setString("Par_Descripcion",cargosObjArchivosList.getDescripcion());

									sentenciaStore.setDouble("Par_Cargo",Utileria.convierteDoble(cargosObjArchivosList.getMontoCargo()));

									sentenciaStore.setDouble("Par_Abono",Utileria.convierteDoble(cargosObjArchivosList.getMontoAbono()));
									//Parametros de Salida

									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",transaccion);

							        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									ResultadoCargaArchivosObjetadosBean mensajeTransaccion = new ResultadoCargaArchivosObjetadosBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CargosObjArchivosDAO.altaCargosObj");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							}
						);
						if(mensajeBean ==  null){
							mensajeBean = new ResultadoCargaArchivosObjetadosBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .CargosObjArchivosDAO.altaCargosObj");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de cargos objetados" + e);
						e.printStackTrace();
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}



}