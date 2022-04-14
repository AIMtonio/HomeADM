package nomina.dao;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;

import java.io.BufferedReader;
import java.io.FileReader;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;

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

import nomina.bean.ProcAfiliaBajaCtaClabeBean;
import nomina.bean.ResultadoCargaArchivosAfiliacionBean;

public class ProcAfiliaBajaCtaClabeDAO extends BaseDAO{

	public ProcAfiliaBajaCtaClabeDAO (){
		super();
	}

	// -------------- Tipo Consulta ----------------
	public static interface Enum_Con_Afiliacion{
		int numAfiliacion	= 1;
	}

	final	String saltoLinea="\n";

	/**
	 *
	 * @param procAfiliaBajaCtaClabeBean : Bean para el registro de información de Afiliaciones
	 * @param result : Resultado Lectura de Archivo
	 * @param numeroTransaccion : Numero de Transaccion
	 * @return
	 */
	public ResultadoCargaArchivosAfiliacionBean altaAfiliacionesCtaClabe(final ProcAfiliaBajaCtaClabeBean procAfiliaBajaCtaClabe,
			final ResultadoCargaArchivosAfiliacionBean result, final double numeroTransaccion ){
		ResultadoCargaArchivosAfiliacionBean resultCarga = new ResultadoCargaArchivosAfiliacionBean();

		resultCarga = (ResultadoCargaArchivosAfiliacionBean) transactionTemplate.execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				try {
					MensajeTransaccionBean mensaje = null;
					// Realiza el registro de informacion de Afiliaciones
					mensaje = altaAfiliacionesCtaClabe(procAfiliaBajaCtaClabe, numeroTransaccion);

					result.setNumero(mensaje.getNumero());
					result.setDescripcion(mensaje.getDescripcion());

					if(mensaje.getNumero()==0){
						result.setExitosos(result.getExitosos()+1);
					}else{
						result.setFallidos(result.getFallidos()+1);
						result.setDescripcion("Error en Línea:"+(result.getExitosos() + result.getFallidos())+" <br> "
								+mensaje.getDescripcion());
					}

				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(this.getClass()+" - "+"Error en el registro de Afiliaciones", e);
					result.setFallidos(result.getFallidos()+1);
				}
				return result;
			}
		});
		return result;
	}

	/**
	 *
	 * @param procAfiliaBajaCtaClabeBean
	 * @param numeroTransaccion : Numero de transaccion en el registro de información de Afiliaciones
	 * @return
	 */
	public MensajeTransaccionBean altaAfiliacionesCtaClabe(final ProcAfiliaBajaCtaClabeBean procAfiliaBajaCtaClabeBean,final double numeroTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call TMPAFILIACUENTASCLABEALT(?,?,?,?,  ?,?,?,  ?,?,?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_CuentaClabe",procAfiliaBajaCtaClabeBean.getCuentaClabe());
									sentenciaStore.setString("Par_ClaveAfiliacion",procAfiliaBajaCtaClabeBean.getClaveAfiliacion());
									sentenciaStore.setString("Par_Tipo",procAfiliaBajaCtaClabeBean.getTipo());
									sentenciaStore.setString("Par_NumAfiliacionID",procAfiliaBajaCtaClabeBean.getNumAfiliacionID());

									//Parametros de OutPut
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",(long) numeroTransaccion);

									loggerSAFI.info(this.getClass()+" - "+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}

									return mensajeTransaccion;
								}
							}
							);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(this.getClass()+" - "+"Error el registro de información de Afiliaciones", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 *
	 * @param rutaArchivo : Ruta de Alojamiento del Archivo de Afiliación para su Lectura y validaciones
	 * @param procAfiliaBajaCtaClabeBean
	 * @return
	 */
	public ResultadoCargaArchivosAfiliacionBean cargaArchivo(final String rutaArchivo, final ProcAfiliaBajaCtaClabeBean procAfiliaBajaCtaClabeBean){
		ResultadoCargaArchivosAfiliacionBean resultado = new ResultadoCargaArchivosAfiliacionBean();
		resultado = (ResultadoCargaArchivosAfiliacionBean)transactionTemplate.execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				ResultadoCargaArchivosAfiliacionBean resultadoCarga = new ResultadoCargaArchivosAfiliacionBean();
				resultadoCarga.setExitosos(0);
				resultadoCarga.setFallidos(0);
				int tamanoLista=0;
				try{
					List <ProcAfiliaBajaCtaClabeBean> procAfiliaBajaCtaClabe = leeArchivo(rutaArchivo,procAfiliaBajaCtaClabeBean);

					if(procAfiliaBajaCtaClabe!=null){
						tamanoLista= procAfiliaBajaCtaClabe.size();

						Iterator <ProcAfiliaBajaCtaClabeBean> iterList = procAfiliaBajaCtaClabe.iterator();

						String motivoDescripcion = saltoLinea+ "El Archivo se ha cargado Exitosamente.";

						ProcAfiliaBajaCtaClabeBean procAfiliaBean;

						if(procAfiliaBajaCtaClabe!=null && procAfiliaBajaCtaClabe.size() > 0){
							double numtransacc = transaccionDAO.generaNumeroTransaccionOut();
							double numeroTransaccion = numtransacc;

							ProcAfiliaBajaCtaClabeBean procAfiliaBajaCta = new ProcAfiliaBajaCtaClabeBean();
							procAfiliaBajaCta = consultaNumeroAfiliacion(procAfiliaBajaCtaClabeBean, Enum_Con_Afiliacion.numAfiliacion);

							String numeroAfiliacion = procAfiliaBajaCta.getNumAfiliacionID();

							while(iterList.hasNext()){
								procAfiliaBean = (ProcAfiliaBajaCtaClabeBean) iterList.next();
								if(procAfiliaBean.getNumError().equals("0")){
									procAfiliaBean.setTipo(procAfiliaBajaCtaClabeBean.getTipo());
									procAfiliaBean.setNumAfiliacionID(numeroAfiliacion);
									resultadoCarga =  altaAfiliacionesCtaClabe(procAfiliaBean, resultadoCarga, numeroTransaccion);

									if(resultadoCarga.getNumero()!=0){
										throw new Exception(resultadoCarga.getDescripcion());
									}

									resultadoCarga.setDescripcion ("" +
											"<table border='0'>" +
											"<tr>" +
											"<td>Total Registros: </td>" +
											"<td style='text-align:right;'>"+tamanoLista+"</td>" +
											"</tr>" +
											"<tr>" +
											"<td>Registros Exitosos: </td>" +
											"<td style='text-align:right;'>"+resultadoCarga.getExitosos()+"</td>" +
											"</tr>" +
											"<tr>" +
											"<td>Registros Fallidos: </td>" +
											"<td style='text-align:right;'>"+resultadoCarga.getFallidos()+"</td>" +
											"</tr>" +
											"<tr>" +
											"<td>Descripción: </td>" +
											"</tr>" +
											"<tr>" +
											"<td style='text-align:justify;'>"+motivoDescripcion+"</td>" +
											"</tr>" +
											"</table>" +
											"");
								}else{
									resultadoCarga.setFallidos(resultadoCarga.getFallidos()+1);
									resultadoCarga.setDescripcion(procAfiliaBean.getDescError());
									throw new Exception(resultadoCarga.getDescripcion());
								}
							}
						}else{
							resultadoCarga.setNumero(999);
							resultadoCarga.setDescripcion("Asegúrese de Subir el Archivo con el Formato Correcto.");
							throw new Exception(resultadoCarga.getDescripcion());
						}
					}else{
						resultadoCarga.setDescripcion("Asegúrese de Subir el Archivo con el Formato Correcto.");
						throw new Exception(resultadoCarga.getDescripcion());
					}
				}catch(Exception e){
					e.printStackTrace();
					loggerSAFI.error(this.getClass()+" - "+"Error en carga de Archivo", e);
					resultadoCarga.setConsecutivoInt("0");
					resultadoCarga.setConsecutivoString("0");
					resultadoCarga.setNumero(999);

					resultadoCarga.setDescripcion ("" +
							"<table border='0'>" +
							"<tr>" +
							"<td>Total Registros: </td>" +
							"<td style='text-align:right;'>"+tamanoLista+"</td>" +
							"</tr>" +
							"<tr>" +
							"<td>Registros Exitosos: </td>" +
							"<td style='text-align:right;'>"+resultadoCarga.getExitosos()+"</td>" +
							"</tr>" +
							"<tr>" +
							"<td>Registros Fallidos: </td>" +
							"<td style='text-align:right;'>"+resultadoCarga.getFallidos()+"</td>" +
							"</tr>" +
							"<tr>" +
							"<td>Descripción: </td>" +
							"</tr>" +
							"<tr>" +
							"<td style='text-align:justify;'>"+resultadoCarga.getDescripcion()+"</td>" +
							"</tr>" +
							"</table>" +
							"");

					transaction.setRollbackOnly();
				}

				return resultadoCarga;
			}
		});
		return resultado;
	}

	/**
	 *
	 * @param rutaArchivo : Ruta de Alojamiento del Archivo de Afiliación para su Lectura
	 * @return
	 */
	public List<ProcAfiliaBajaCtaClabeBean> leeArchivo(String rutaArchivo,final ProcAfiliaBajaCtaClabeBean procAfiliaBajaCtaClabeBean){
		ArrayList<ProcAfiliaBajaCtaClabeBean> listaAfilia = new ArrayList<ProcAfiliaBajaCtaClabeBean>();
		BufferedReader bufferedReader;
		String [] arreglo = null;
		int contadorErr =0;

		ProcAfiliaBajaCtaClabeBean procAfiliaBajaCta;
		String renglon;

		int tamEncabezado = 1;
		int numeroLinea = 0;

		String cuentaClabe ="";
		String claveRespuesta ="";

		try {
			bufferedReader = new BufferedReader(new FileReader(rutaArchivo));

			while ((renglon = bufferedReader.readLine())!= null){
				numeroLinea +=1;

				if(tamEncabezado < numeroLinea && !renglon.trim().equals("") ){
					arreglo = renglon.split("");
					procAfiliaBajaCta = new ProcAfiliaBajaCtaClabeBean();
					procAfiliaBajaCta.setNumError("0");


					cuentaClabe		=	arreglo[102].trim()+arreglo[103].trim()+arreglo[104].trim()+arreglo[105].trim()+arreglo[106].trim()
									 +  arreglo[107].trim()+arreglo[108].trim()+arreglo[109].trim()+arreglo[110].trim()+arreglo[111].trim()
									 +  arreglo[112].trim()+arreglo[113].trim()+arreglo[114].trim()+arreglo[115].trim()+arreglo[116].trim()
									 +  arreglo[117].trim()+arreglo[118].trim()+arreglo[119].trim();


					claveRespuesta = arreglo[162].trim()+arreglo[163].trim();

					if(cuentaClabe.length() == 18){
						procAfiliaBajaCta.setCuentaClabe(cuentaClabe);

					}else{
						procAfiliaBajaCta.setNumError("111");
						procAfiliaBajaCta.setDescError("Error en Línea: " +numeroLinea +saltoLinea+" La Cuenta Clabe No Tiene una Longitud de 18 Caracteres.");
						procAfiliaBajaCta.setLineaError(numeroLinea);
					}

					procAfiliaBajaCta.setClaveAfiliacion(claveRespuesta);


					if(arreglo[164].equals("B") && procAfiliaBajaCtaClabeBean.getTipo().equals("A") ){
						procAfiliaBajaCta.setNumError("222");
						procAfiliaBajaCta.setDescError("Error en Línea: " +numeroLinea +saltoLinea+" El Tipo de Archivo debe ser Baja.");
						procAfiliaBajaCta.setLineaError(numeroLinea);
					}

					if(arreglo[164].equals("A") && procAfiliaBajaCtaClabeBean.getTipo().equals("B") ){
						procAfiliaBajaCta.setNumError("333");
						procAfiliaBajaCta.setDescError("Error en Línea: " +numeroLinea +saltoLinea+" El Tipo de Archivo debe ser Alta.");
						procAfiliaBajaCta.setLineaError(numeroLinea);
					}

					if(!arreglo[164].equals("A") && !arreglo[164].equals("B") ){
						procAfiliaBajaCta.setNumError("444");
						procAfiliaBajaCta.setDescError("Error en Línea: " +numeroLinea +saltoLinea+" El Tipo de Archivo no coincide con Alta o Baja.");
						procAfiliaBajaCta.setLineaError(numeroLinea);
					}


					if(!procAfiliaBajaCta.getNumError().equals("0")){
						contadorErr++;
					}

					listaAfilia.add(procAfiliaBajaCta);

				}
			}

		}catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+"Error en Leer el Archivo", e);

			listaAfilia=null;
		}

		return listaAfilia;
	}

	/**
	 *
	 * @param listaBean : Metodo para mandar a llamar al metodo para el proceso de Afiliacion/Bajas Cuenta Clabe
	 * @return
	 */
	public MensajeTransaccionBean procesaAfiliacionBajasCuentaClabe(final List listaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					ProcAfiliaBajaCtaClabeBean procAfiliaBajaCtaClabeBean;

					if(listaBean!=null){
						for(int i=0; i<listaBean.size(); i++){
							/* obtenemos un bean de la lista */
							procAfiliaBajaCtaClabeBean = (ProcAfiliaBajaCtaClabeBean)listaBean.get(i);
								mensajeBean = procesaAfiliacionBajasCuentaClabe(procAfiliaBajaCtaClabeBean,parametrosAuditoriaBean.getNumeroTransaccion());
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en proceso de Afiliación/Bajas Cuentas Clabes", e);
					if(mensajeBean.getNumero()==0){
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

	/**
	 *
	 * @param procAfiliaBajaCtaClabeBean
	 * @param NumeroTransaccion : Numero de Transaccion
	 * @return
	 */
	public MensajeTransaccionBean procesaAfiliacionBajasCuentaClabe(final ProcAfiliaBajaCtaClabeBean procAfiliaBajaCtaClabeBean,final long numeroTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call AFILIACUENTASCLABESPRO(?,?,?,?,  ?,?,?,  ?,?,?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_CuentaClabe",procAfiliaBajaCtaClabeBean.getCuentaClabe());
									sentenciaStore.setString("Par_ClaveAfiliacion",procAfiliaBajaCtaClabeBean.getClaveAfiliacion());
									sentenciaStore.setString("Par_Tipo",procAfiliaBajaCtaClabeBean.getTipo());
									sentenciaStore.setString("Par_NumAfiliacionID",procAfiliaBajaCtaClabeBean.getNumAfiliacionID());

									//Parametros de OutPut
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);

									loggerSAFI.info(this.getClass()+" - "+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}

									return mensajeTransaccion;
								}
							}
							);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(this.getClass()+" - "+"Error en proceso de Afiliación/Bajas Cuentas Clabes", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 *
	 * @param procAfiliaBajaCtaClabe
	 * @param tipoConsulta : Consulta de Numero de Afiliacion
	 * @return
	 */
	public ProcAfiliaBajaCtaClabeBean consultaNumeroAfiliacion(ProcAfiliaBajaCtaClabeBean procAfiliaBajaCtaClabe, int tipoConsulta) {
		ProcAfiliaBajaCtaClabeBean procAfiliaBajaCtaClabeBean= new ProcAfiliaBajaCtaClabeBean();
		try{
			//Query con el Store Procedure
			String query = "call TMPAFILIACUENTASCLABECON(?,?,?,?,?, ?,?,?,?);";

			Object[] parametros = {
									procAfiliaBajaCtaClabe.getTipo(),
									tipoConsulta,

									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"ProcAfiliaBajaCtaClabeDAO.consultaNumAfiliacion",
									parametrosAuditoriaBean.getSucursal(),
									parametrosAuditoriaBean.getNumeroTransaccion()
									};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TMPAFILIACUENTASCLABECON(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ProcAfiliaBajaCtaClabeBean procAfiliaBajaCtaClabe = new ProcAfiliaBajaCtaClabeBean();
					procAfiliaBajaCtaClabe.setNumAfiliacionID(resultSet.getString("Var_NumAfiliacionID"));
					return procAfiliaBajaCtaClabe;
				}// trows ecexeption
			});//lista

			procAfiliaBajaCtaClabeBean= matches.size() > 0 ? (ProcAfiliaBajaCtaClabeBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta Numero de Afiliación", e);
		}
		return procAfiliaBajaCtaClabeBean;
	}

	/**
	 *
	 * @param procAfiliaBajaCtaClabeBean
	 * @param tipoLista : Lista por Procesar de Afiliación/Bajas Cuenta Clabe
	 * @return
	 */
	public List listaPorProcesar(ProcAfiliaBajaCtaClabeBean procAfiliaBajaCtaClabeBean, int tipoLista) {
		List listaAfiliaBajaCtaClabe=null;
		try{
		String query = "call TMPAFILIACUENTASCLABELIS(?,?,?,?,?,	?,?,?,?);";
		Object[] parametros = {
								procAfiliaBajaCtaClabeBean.getTipo(),
								tipoLista,

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"ProcAfiliaBajaCtaClabeDAO.listaGrid",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
								};
		loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TMPAFILIACUENTASCLABELIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				ProcAfiliaBajaCtaClabeBean listaAfiliacion = new ProcAfiliaBajaCtaClabeBean();

				listaAfiliacion.setNumAfiliacionID(resultSet.getString("NumAfiliacionID"));
				listaAfiliacion.setClienteID(resultSet.getString("ClienteID"));
				listaAfiliacion.setNombCliente(resultSet.getString("NombreCliente"));
				listaAfiliacion.setInstitucionID(resultSet.getString("InstitucionID"));
				listaAfiliacion.setNombInstitucion(resultSet.getString("NombreInstitucion"));
				listaAfiliacion.setCuentaClabe(resultSet.getString("CuentaClabe"));
				listaAfiliacion.setAfiliada(resultSet.getString("Afiliada"));
				listaAfiliacion.setComentario(resultSet.getString("Comentario"));
				listaAfiliacion.setClaveAfiliacion(resultSet.getString("ClaveAfiliacion"));
				listaAfiliacion.setTipo(resultSet.getString("Tipo"));

				return listaAfiliacion;
			}
		});

		listaAfiliaBajaCtaClabe= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de detalles de afiliación", e);
		}
		return listaAfiliaBajaCtaClabe;

		}
}
