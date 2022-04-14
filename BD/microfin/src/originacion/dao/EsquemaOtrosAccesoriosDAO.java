package originacion.dao;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import originacion.bean.CreditosPlazosBean;
import originacion.bean.EsquemaOtrosAccesoriosBean;


public class EsquemaOtrosAccesoriosDAO extends BaseDAO {

	java.sql.Date fecha = null;

	public EsquemaOtrosAccesoriosDAO(){
		super();
	}

	private final static String salidaPantalla = "S";


	/**
	 * Método para dar de alta Esquemas de Accesorios por Producto de Crédito
	 * @param otrosAccesoriosBean
	 * @param NumeroTransaccion
	 * @return
	 */
	public MensajeTransaccionBean alta(final EsquemaOtrosAccesoriosBean esquemaOtrosAccesoriosBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call ESQACCESORIOSPRODALT(?,?,?,?,?,"
																			+ "?,?,?,?,?,"
																			+ "?,?,?,?,?,"
																			+ "?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ProducCreditoID",Utileria.convierteEntero(esquemaOtrosAccesoriosBean.getProducCreditoID()));
									sentenciaStore.setInt("Par_AccesorioID",Utileria.convierteEntero(esquemaOtrosAccesoriosBean.getAccesorioID()));
									sentenciaStore.setInt("Par_InstitNominaID", Utileria.convierteEntero(esquemaOtrosAccesoriosBean.getInstitNominaID()));
									sentenciaStore.setString("Par_CobraIVA", esquemaOtrosAccesoriosBean.getCobraIVA());
									sentenciaStore.setString("Par_GeneraInteres", esquemaOtrosAccesoriosBean.getGeneraInteres());
									sentenciaStore.setString("Par_CobraIVAInteres", esquemaOtrosAccesoriosBean.getCobraIVAInteres());
									sentenciaStore.setString("Par_TipoFormaCobro", esquemaOtrosAccesoriosBean.getFormaCobro());
									sentenciaStore.setString("Par_TipoPago", esquemaOtrosAccesoriosBean.getTipoPago());
									sentenciaStore.setString("Par_BaseCalculo", esquemaOtrosAccesoriosBean.getBaseCalculo());

									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);
									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .EsquemaOtrosAccesoriosDAO.alta");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
							);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .EsquemaOtrosAccesoriosDAO.alta");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de Esquema Otros Accesorios: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método para Modificar Esquemas de Accesorios por Producto de Crédito
	 * @param otrosAccesoriosBean
	 * @param NumeroTransaccion
	 * @return
	 */
	public MensajeTransaccionBean modifica(final EsquemaOtrosAccesoriosBean esquemaOtrosAccesoriosBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call ESQACCESORIOSPRODMOD(?,?,?,?,?,"
																			+ "?,?,?,?,?,"
																			+ "?,?,?,?,?,"
																			+ "?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ProducCreditoID",Utileria.convierteEntero(esquemaOtrosAccesoriosBean.getProducCreditoID()));
									sentenciaStore.setInt("Par_AccesorioID",Utileria.convierteEntero(esquemaOtrosAccesoriosBean.getAccesorioID()));
									sentenciaStore.setInt("Par_InstitNominaID",Utileria.convierteEntero(esquemaOtrosAccesoriosBean.getInstitNominaID()));
									sentenciaStore.setString("Par_CobraIVA", esquemaOtrosAccesoriosBean.getCobraIVA());
									sentenciaStore.setString("Par_GeneraInteres", esquemaOtrosAccesoriosBean.getGeneraInteres());
									sentenciaStore.setString("Par_CobraIVAInteres", esquemaOtrosAccesoriosBean.getCobraIVAInteres());
									sentenciaStore.setString("Par_TipoFormaCobro", esquemaOtrosAccesoriosBean.getFormaCobro());
									sentenciaStore.setString("Par_TipoPago", esquemaOtrosAccesoriosBean.getTipoPago());
									sentenciaStore.setString("Par_BaseCalculo", esquemaOtrosAccesoriosBean.getBaseCalculo());

									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);
									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .EsquemaOtrosAccesoriosDAO.modifica");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
							);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .EsquemaOtrosAccesoriosDAO.modifica");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al modificar Esquema Otros Accesorios: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean altaGrid(final EsquemaOtrosAccesoriosBean esquemaOtrosAccesorios){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean)((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction){
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					mensajeBean = (MensajeTransaccionBean)((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
								new CallableStatementCreator(){
									public CallableStatement createCallableStatement(Connection arg0) throws SQLException{
										String query = "CALL ESQACCESPRODCREALT(" + "?,?,?,?,?,?,"
																				+ "?,?,?,?,?,?,"
																				+ "?,?,?,?,?,?,"
																				+"?,?)";

										CallableStatement sentenciaStore = arg0.prepareCall(query);

										sentenciaStore.setInt("Par_ProducCreditoID",Utileria.convierteEntero(esquemaOtrosAccesorios.getProducCreditoID()));
										sentenciaStore.setInt("Par_AccesorioID", Utileria.convierteEntero(esquemaOtrosAccesorios.getAccesorioID()));
										sentenciaStore.setInt("Par_ConvenioID", Utileria.convierteEntero(esquemaOtrosAccesorios.getConvenioID()));
										sentenciaStore.setInt("Par_PlazoID", Utileria.convierteEntero(esquemaOtrosAccesorios.getPlazoID()));
										sentenciaStore.setInt("Par_CicloIni", Utileria.convierteEntero(esquemaOtrosAccesorios.getCicloIni()));
										sentenciaStore.setInt("Par_CicloFin", Utileria.convierteEntero(esquemaOtrosAccesorios.getCicloFin()));
										sentenciaStore.setDouble("Par_MontoMin", Utileria.convierteDoble(esquemaOtrosAccesorios.getMontoMin()));
										sentenciaStore.setDouble("Par_MontoMax", Utileria.convierteDoble(esquemaOtrosAccesorios.getMontoMax()));

										sentenciaStore.setDouble("Par_Monto", Utileria.convierteDoble(esquemaOtrosAccesorios.getMontoPorcentaje()));
										sentenciaStore.setInt("Par_NivelID", Utileria.convierteEntero(esquemaOtrosAccesorios.getNivelID()));
										sentenciaStore.setString("Par_Salida",salidaPantalla);
										sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
										sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);
										//Parametros de Auditoriari
										sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
										sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
										sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
										sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
										sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
										sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
										sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

										loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
										return sentenciaStore;
									}
								},new CallableStatementCallback() {
									public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException{
										MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
										if (callableStatement.execute()) {
											ResultSet resultadoStore = callableStatement.getResultSet();

											resultadoStore.next();
											mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadoStore.getString("NumErr")));
											mensajeTransaccion.setDescripcion(resultadoStore.getString("ErrMen"));
											mensajeTransaccion.setNombreControl(resultadoStore.getString("Control"));
										}else{
											mensajeTransaccion.setNumero(999);
											mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " EsquemaOtrosAccesoriosDAO.altaGrid");
											mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
											mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
										}
										return mensajeTransaccion;
									}
								}
							);
					if(mensajeBean==null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + "EsquemaOtrosAccesoriosDAO.altaGrid");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				}catch(Exception e){
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de esquema de accesorios por producto: ",e);
				}
				return mensajeBean;
			}
		});

		return mensaje;
	}

	public MensajeTransaccionBean altaPlazosMonto(final EsquemaOtrosAccesoriosBean esquemaOtrosAccesorios) {

		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensajeTransaccion = (MensajeTransaccionBean)((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					mensajeBean = bajaElementosGrid(esquemaOtrosAccesorios);
					if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
					if(esquemaOtrosAccesorios.getNumPlazosSeleccionados()!=null && esquemaOtrosAccesorios.getPlazoID()!=null){
						String[] arrayConvenioID = null;
						String[] arrayNumConSeleccionados = null;
						String[] arrayPlazoID = esquemaOtrosAccesorios.getPlazoID().split(",");

						if(esquemaOtrosAccesorios.getConvenioID() != null && !esquemaOtrosAccesorios.getConvenioID().trim().isEmpty()){
							arrayConvenioID = esquemaOtrosAccesorios.getConvenioID().split(",");
							arrayNumConSeleccionados = esquemaOtrosAccesorios.getNumConveniosSeleccionados().split(",");

							List<String> listConvenioID = new ArrayList<String>();
							List<String> listNumConSeleccionados = new ArrayList<String>();

							if(arrayNumConSeleccionados != null && arrayConvenioID != null) {
								int numConvenios = 0;
								for (int i = 0; i < arrayNumConSeleccionados.length; i++) {
									List<String> subListConvenios = new ArrayList<String>();
									int totalConvenios = Utileria.convierteEntero(arrayNumConSeleccionados[i]);
									String[] subArrayConvenios = Arrays.copyOfRange(arrayConvenioID, numConvenios, (numConvenios + totalConvenios));

									for (int j = 0; j < subArrayConvenios.length; j++) {
										if(!"0".equals(subArrayConvenios[j])){
											subListConvenios.add(subArrayConvenios[j]);
										}
									}

									listConvenioID.addAll(subListConvenios);
									listNumConSeleccionados.add(subListConvenios.size()+"");
									numConvenios += totalConvenios;
								}
							}

							arrayConvenioID = listConvenioID.toArray(new String[0]);
							esquemaOtrosAccesorios.setNumConveniosSeleccionados(StringUtils.join(listNumConSeleccionados, ","));
						} else {
							arrayConvenioID = new String[arrayPlazoID.length];
							Arrays.fill(arrayConvenioID, "0");
						}

						List<String> listPlazoID = new ArrayList<String>();
						List<String> listNumPlazoSeleccionados = new ArrayList<String>();

						String[] arrayNumPlazoSeleccionado = esquemaOtrosAccesorios.getNumPlazosSeleccionados().split(",");

						if(arrayNumPlazoSeleccionado != null && arrayPlazoID != null){
							int numPlazos = 0;
							for (int i = 0; i < arrayNumPlazoSeleccionado.length; i++) {
								List<String> subListPlazos = new ArrayList<String>();
								int totalPlazos = Utileria.convierteEntero(arrayNumPlazoSeleccionado[i]);
								String[] subArrayPlazos = Arrays.copyOfRange(arrayPlazoID, numPlazos, (numPlazos + totalPlazos));

								for (int j = 0; j < subArrayPlazos.length; j++) {
									if(!"0".equals(subArrayPlazos[j])){
										subListPlazos.add(subArrayPlazos[j]);
									}
								}

								listPlazoID.addAll(subListPlazos);
								listNumPlazoSeleccionados.add(subListPlazos.size()+"");
								numPlazos += totalPlazos;
							}
						}

						arrayPlazoID = listPlazoID.toArray(new String[0]);
						arrayNumPlazoSeleccionado = listNumPlazoSeleccionados.toArray(new String[0]);

						if(esquemaOtrosAccesorios.getConvenioID() != null && esquemaOtrosAccesorios.getNumConveniosSeleccionados()!=null
								&& !esquemaOtrosAccesorios.getNumConveniosSeleccionados().trim().isEmpty()){
							arrayNumConSeleccionados = esquemaOtrosAccesorios.getNumConveniosSeleccionados().split(",");
						} else {
							arrayNumConSeleccionados = new String[arrayNumPlazoSeleccionado.length];
							Arrays.fill(arrayNumConSeleccionados, "1");
						}

						String[] arrayCicloIni = esquemaOtrosAccesorios.getCicloIni().split(",");
						String[] arrayCicloFin = esquemaOtrosAccesorios.getCicloFin().split(",");
						String[] arrayMontoMin = esquemaOtrosAccesorios.getMontoMin().split(",");
						String[] arrayMontoMax = esquemaOtrosAccesorios.getMontoMax().split(",");
						String[] arrayMonto = esquemaOtrosAccesorios.getMontoPorcentaje().split(",");
						String[] arrayNivelID = esquemaOtrosAccesorios.getNivelID().split(",");

						int numPlazos=0;
						int numConvenios=0;
						int count = arrayNumPlazoSeleccionado.length;

						EsquemaOtrosAccesoriosBean esqOtrosAccesorios = new EsquemaOtrosAccesoriosBean();
						esqOtrosAccesorios.setProducCreditoID(esquemaOtrosAccesorios.getProducCreditoID());
						esqOtrosAccesorios.setAccesorioID(esquemaOtrosAccesorios.getAccesorioID());

						for(int i=0;i<count;i++){

							int totalConvenios = Utileria.convierteEntero(arrayNumConSeleccionados[i]);
							int totalPlazos = Utileria.convierteEntero(arrayNumPlazoSeleccionado[i]);
							String cicloIni = arrayCicloIni[i];
							String cicloFin = arrayCicloFin[i];
							String montoMin = arrayMontoMin[i];
							String montoMax = arrayMontoMax[i];
							String monto = arrayMonto[i];
							String nivelID = arrayNivelID[i];

							String[] subArrayConvenios = Arrays.copyOfRange(arrayConvenioID, numConvenios, (numConvenios + totalConvenios));
							String[] subArrayPlazos = Arrays.copyOfRange(arrayPlazoID, numPlazos, (numPlazos + totalPlazos));

							for (int j=0; j<subArrayConvenios.length; j++) {
								for (int k=0; k<subArrayPlazos.length; k++) {
									esqOtrosAccesorios.setConvenioID(subArrayConvenios[j]);
									esqOtrosAccesorios.setPlazoID(subArrayPlazos[k]);
									esqOtrosAccesorios.setCicloIni(cicloIni);
									esqOtrosAccesorios.setCicloFin(cicloFin);
									esqOtrosAccesorios.setMontoMin(montoMin);
									esqOtrosAccesorios.setMontoMax(montoMax);
									esqOtrosAccesorios.setMontoPorcentaje(monto);
									esqOtrosAccesorios.setNivelID(nivelID);
									mensajeBean = altaGrid(esqOtrosAccesorios);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								}
							}
							numConvenios += totalConvenios;
							numPlazos += totalPlazos;
						}
					}
				} catch(Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al dar de alta esquema de accesorios por credito: ",e);
				}
				return mensajeBean;
			}
		});
		return mensajeTransaccion;
	}

	public MensajeTransaccionBean bajaElementosGrid(final EsquemaOtrosAccesoriosBean esquemaOtrosAccesorios){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean)((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction){
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					mensajeBean = (MensajeTransaccionBean)((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
								new CallableStatementCreator() {
									public CallableStatement createCallableStatement(Connection arg0)throws SQLException {
										String query = "CALL ESQACCESPRODCREBAJ(" + "?,?,?,?,?,?,"
																				  + "?,?,?,?,?,"
																				  + "?,?)";
										CallableStatement sentenciaStore = arg0.prepareCall(query);

										sentenciaStore.setInt("Par_ProducCreditoID",Utileria.convierteEntero(esquemaOtrosAccesorios.getProducCreditoID()));
										sentenciaStore.setInt("Par_AccesorioID", Utileria.convierteEntero(esquemaOtrosAccesorios.getAccesorioID()));
										sentenciaStore.setInt("Par_EmpresaNomina", Utileria.convierteEntero(esquemaOtrosAccesorios.getEmpresaNominaID()));

										sentenciaStore.setString("Par_Salida",salidaPantalla);
										sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
										sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);
										//Parametros de Auditoria
										sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
										sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
										sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
										sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
										sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
										sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
										sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

										loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
										return sentenciaStore;
									}
								},new CallableStatementCallback() {
									public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException{
										MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
										if(callableStatement.execute()){
											ResultSet resultadoStore = callableStatement.getResultSet();

											resultadoStore.next();
											mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadoStore.getString("NumErr")));
											mensajeTransaccion.setDescripcion(resultadoStore.getString("ErrMen"));
											mensajeTransaccion.setNombreControl(resultadoStore.getString("Control"));
										}else{
											mensajeTransaccion.setNumero(999);
											mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + "EsquemaOtrosAccesoriosDAO.bajaElementosGrid");
											mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
											mensajeTransaccion.setConsecutivoInt(Constantes.STRING_VACIO);
										}
										return mensajeTransaccion;
									}
 								}
							);
				}catch(Exception e){
					if(mensajeBean.getNumero() == 0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la baja de Esquemas Otros Accesorios",e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método para consultar un esquema de accesorios
	 * @param esquemaOtrosAccesorios
	 * @param tipoConsulta
	 * @return
	 */
	public EsquemaOtrosAccesoriosBean consulta(EsquemaOtrosAccesoriosBean esquemaOtrosAccesorios,int tipoConsulta){
		String query = "CALL ESQACCESORIOSPRODCON(?,?,?,?,  ?,?,?,?,?,?,?);";

		Object[] parametros = {
			Utileria.convierteEntero(esquemaOtrosAccesorios.getProducCreditoID()),
			Utileria.convierteEntero(esquemaOtrosAccesorios.getAccesorioID()),
			Utileria.convierteEntero(esquemaOtrosAccesorios.getInstitNominaID()),
			tipoConsulta,

			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO,
			Constantes.FECHA_VACIA,
			Constantes.STRING_VACIO,
			Constantes.STRING_VACIO,
			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "CALL ESQACCESORIOSPRODCON(" + Arrays.toString(parametros) + ")");
		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException{
				EsquemaOtrosAccesoriosBean esquemaOAccesoriosBean = new EsquemaOtrosAccesoriosBean();

				esquemaOAccesoriosBean.setProducCreditoID(String.valueOf(resultSet.getInt("ProductoCreditoID")));
				esquemaOAccesoriosBean.setAccesorioID(String.valueOf(resultSet.getInt("AccesorioID")));
				esquemaOAccesoriosBean.setInstitNominaID(String.valueOf(resultSet.getInt("InstitNominaID")));
				esquemaOAccesoriosBean.setCobraIVA(resultSet.getString("CobraIVA"));
				esquemaOAccesoriosBean.setGeneraInteres(resultSet.getString("GeneraInteres"));
				esquemaOAccesoriosBean.setCobraIVAInteres(resultSet.getString("CobraIVAInteres"));
				esquemaOAccesoriosBean.setFormaCobro(resultSet.getString("TipoFormaCobro"));
				esquemaOAccesoriosBean.setTipoPago(resultSet.getString("TipoPago"));
				esquemaOAccesoriosBean.setBaseCalculo(resultSet.getString("BaseCalculo"));

				return esquemaOAccesoriosBean;
			}
		});

		return matches.size() > 0 ? (EsquemaOtrosAccesoriosBean) matches.get(0) : null;
	}


	/**
	 * Método para consulta datos generales del accesorio de un crédito
	 * @param esquemaOtrosAccesorios
	 * @param tipoConsulta
	 * @return
	 */
	public EsquemaOtrosAccesoriosBean consultaDatosAc(EsquemaOtrosAccesoriosBean esquemaOtrosAccesorios,int tipoConsulta){
		String query = "CALL DETALLEACCESORIOSCON(?,?,?,?,?," +
												 "?,?,?,?,?);";

		Object[] parametros = {
			Utileria.convierteEntero(esquemaOtrosAccesorios.getCreditoID()),
			Utileria.convierteEntero(esquemaOtrosAccesorios.getAccesorioID()),
			tipoConsulta,

			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO,
			Constantes.FECHA_VACIA,
			Constantes.STRING_VACIO,
			Constantes.STRING_VACIO,
			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "CALL DETALLEACCESORIOSCON(" + Arrays.toString(parametros) + ")");
		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException{
				EsquemaOtrosAccesoriosBean esquemaOAccesoriosBean = new EsquemaOtrosAccesoriosBean();

				esquemaOAccesoriosBean.setAccesorioID(String.valueOf(resultSet.getInt("AccesorioID")));
				esquemaOAccesoriosBean.setCobraIVA(resultSet.getString("CobraIVA"));
				esquemaOAccesoriosBean.setMontoAccesorio(resultSet.getString("MontoAccesorio"));
				esquemaOAccesoriosBean.setMontoIVAAccesorio(resultSet.getString("MontoIVAAccesorio"));
				esquemaOAccesoriosBean.setSaldoAccesorio(resultSet.getString("SaldoVigente"));
				esquemaOAccesoriosBean.setSaldoIVAAccesorio(resultSet.getString("SaldoIVAAccesorio"));
				esquemaOAccesoriosBean.setMontoPagado(resultSet.getString("MontoPagado"));

				return esquemaOAccesoriosBean;
			}
		});

		return matches.size() > 0 ? (EsquemaOtrosAccesoriosBean) matches.get(0) : null;
	}

	/**
	 * Agrupa los esquemas otros accesorios
	 * @param lista
	 * @return
	 */
	private List<EsquemaOtrosAccesoriosBean> agrupaEsquemasOtrosAccesorios(List<EsquemaOtrosAccesoriosBean> lista){
		if(!lista.isEmpty()){
			List<EsquemaOtrosAccesoriosBean> lsGruposEsquema = new ArrayList<EsquemaOtrosAccesoriosBean>();
 			for(EsquemaOtrosAccesoriosBean eoa : lista){
				if(!lsGruposEsquema.contains(eoa)){
					List<String> conveniosSeleccionadosID = new ArrayList<String>();
					List<String> plazosSeleccionadosID = new ArrayList<String>();
					conveniosSeleccionadosID.add(eoa.getConvenioID());
					plazosSeleccionadosID.add(eoa.getPlazoID());
					eoa.setConveniosSeleccionadosID(conveniosSeleccionadosID);
					eoa.setPlazosSeleccionadosID(plazosSeleccionadosID);
					lsGruposEsquema.add(eoa);
				}else{
					EsquemaOtrosAccesoriosBean esquemaOtrosAccesorios = lsGruposEsquema.get(lsGruposEsquema.indexOf(eoa));
					if(!esquemaOtrosAccesorios.getConveniosSeleccionadosID().contains(eoa.getConvenioID()))
						esquemaOtrosAccesorios.getConveniosSeleccionadosID().add(eoa.getConvenioID());

					if(!esquemaOtrosAccesorios.getPlazosSeleccionadosID().contains(eoa.getPlazoID()))
						esquemaOtrosAccesorios.getPlazosSeleccionadosID().add(eoa.getPlazoID());
				}
			}
 			return lsGruposEsquema;
		}
		return lista;
	}

	public List<EsquemaOtrosAccesoriosBean> lista(EsquemaOtrosAccesoriosBean esquemaOtrosAccesorios, int tipoLista){
		List<EsquemaOtrosAccesoriosBean> lista = new ArrayList<EsquemaOtrosAccesoriosBean>();
		String query = "CALL ESQACCESORIOSPRODLIS(" + "?,?,?,?,?,"
													+ "?,?,?,?,?,"
													+ "?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(esquemaOtrosAccesorios.getProducCreditoID()),
				Constantes.ENTERO_CERO,
				Constantes.DOUBLE_VACIO,
				Constantes.ENTERO_CERO,
				Utileria.convierteEntero(esquemaOtrosAccesorios.getAccesorioID()),
				Utileria.convierteEntero(esquemaOtrosAccesorios.getInstitNominaID()),
				Utileria.convierteEntero(esquemaOtrosAccesorios.getConvenioID()),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL ESQACCESORIOSPRODLIS("+ Arrays.toString(parametros) + ")");
		try{
			List<EsquemaOtrosAccesoriosBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException{
					EsquemaOtrosAccesoriosBean esquemaAccesorios = new EsquemaOtrosAccesoriosBean();

					esquemaAccesorios.setConvenioID(resultSet.getString("ConvenioID"));
					esquemaAccesorios.setPlazoID(resultSet.getString("PlazoID"));
					esquemaAccesorios.setCicloIni(resultSet.getString("CicloIni"));
					esquemaAccesorios.setCicloFin(resultSet.getString("CicloFin"));
					esquemaAccesorios.setMontoPorcentaje(resultSet.getString("Monto"));
					esquemaAccesorios.setNivelID(resultSet.getString("NivelID"));
					esquemaAccesorios.setMontoMin(resultSet.getString("MontoMin"));
					esquemaAccesorios.setMontoMax(resultSet.getString("MontoMax"));

					return esquemaAccesorios;
				}
			});
			if(matches!=null){
				return agrupaEsquemasOtrosAccesorios(matches);
			}
		}catch(Exception e){
			e.getMessage();
		}

		return lista;
	}


	/**
	 * Método que lista los Accesorios de un crédito
	 * @param
	 * @param tipoLista
	 * @return
	 */
	public List listaAc(EsquemaOtrosAccesoriosBean esquemaAccesoriosBean, int tipoLista) {
		List<EsquemaOtrosAccesoriosBean> lista=new ArrayList<EsquemaOtrosAccesoriosBean>();
		String query = "CALL ESQACCESORIOSPRODLIS(?,?,?,?,?,   " +
											 "?,?,?,?,?," +
											 "?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(esquemaAccesoriosBean.getProducCreditoID()),
				Utileria.convierteEntero(esquemaAccesoriosBean.getClienteID()),
				Utileria.convierteDoble(esquemaAccesoriosBean.getMontoCredito().replace(",", "")),
				Utileria.convierteEntero(esquemaAccesoriosBean.getPlazoID()),
				Constantes.ENTERO_CERO,
				Utileria.convierteEntero(esquemaAccesoriosBean.getInstitNominaID()),
				Utileria.convierteEntero(esquemaAccesoriosBean.getConvenioID()),
				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,

				"EsquemaOtrosAccesoriosDAO.listaAc",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"call ESQACCESORIOSPRODLIS(" + Arrays.toString(parametros) + ");");
		try{
			List<EsquemaOtrosAccesoriosBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EsquemaOtrosAccesoriosBean parametro = new EsquemaOtrosAccesoriosBean();
					parametro.setAccesorioID(resultSet.getString("AccesorioID"));
					parametro.setFormaCobro((resultSet.getString("TipoFormaCobro")));
					parametro.setMontoAccesorio(resultSet.getString("MontoAccesorio"));
					parametro.setMontoIVAAccesorio(resultSet.getString("MontoIVAAccesorio"));
					parametro.setCobraIVA(resultSet.getString("CobraIVA"));
					parametro.setNombreCorto(resultSet.getString("NombreCorto"));

					return parametro;
				}
			});
			if(matches!=null){
				return matches;
			}
		} catch(Exception ex){
			loggerSAFI.info("Error en OtrosAccesoriosDAO.listaAc: "+ex.getMessage());
		}
		return lista;
	}

	/**
	 * Método que lista los Accesorios de un crédito
	 * @param
	 * @param tipoLista
	 * @return
	 */
	public List listaAccesoriosCred(EsquemaOtrosAccesoriosBean esquemaAccesoriosBean, int tipoLista) {
		List<EsquemaOtrosAccesoriosBean> lista=new ArrayList<EsquemaOtrosAccesoriosBean>();
		String query = "CALL DETALLEACCESORIOSLIS(?,?,?,?,?,   " +
											 "?,?,?,?,?);";
		Object[] parametros = {
				esquemaAccesoriosBean.getSolicitudCreditoID(),
				esquemaAccesoriosBean.getCreditoID(),
				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,

				"EsquemaOtrosAccesoriosDAO.lista",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"call DETALLEACCESORIOSLIS(" + Arrays.toString(parametros) + ");");
		try{
			List<EsquemaOtrosAccesoriosBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EsquemaOtrosAccesoriosBean parametro = new EsquemaOtrosAccesoriosBean();
					parametro.setAccesorioID(resultSet.getString("AccesorioID"));
					parametro.setFormaCobro((resultSet.getString("TipoFormaCobro")));
					parametro.setMontoAccesorio(resultSet.getString("MontoAccesorio"));
					parametro.setMontoIVAAccesorio(resultSet.getString("MontoIVAAccesorio"));
					parametro.setCobraIVA(resultSet.getString("CobraIVA"));
					parametro.setNombreCorto(resultSet.getString("NombreCorto"));

					return parametro;
				}
			});
			if(matches!=null){
				return matches;
			}
		} catch(Exception ex){
			loggerSAFI.info("Error en OtrosAccesoriosDAO.lista: "+ex.getMessage());
		}
		return lista;
	}

	public List<CreditosPlazosBean> listaCombo(EsquemaOtrosAccesoriosBean esquemaAccesoriosBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "CALL DETALLEACCESORIOSLIS(?,?,?,?,?,   " +
				 "?,?,?,?,?);";
		Object[] parametros = {
				esquemaAccesoriosBean.getSolicitudCreditoID(),
				esquemaAccesoriosBean.getCreditoID(),
				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,

				"EsquemaOtrosAccesoriosDAO.lista",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DETALLEACCESORIOSLIS(" + Arrays.toString(parametros) + ")");

		List<CreditosPlazosBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EsquemaOtrosAccesoriosBean esquemaAccesoriosBean = new EsquemaOtrosAccesoriosBean();
					esquemaAccesoriosBean.setAccesorioID(resultSet.getString("AccesorioID"));
					esquemaAccesoriosBean.setNombreCorto(resultSet.getString("NombreCorto"));
					esquemaAccesoriosBean.setDescripcion(resultSet.getString("Descripcion"));
					esquemaAccesoriosBean.setMontoAccesorio(resultSet.getString("MontoCuota"));
					esquemaAccesoriosBean.setMontoIVAAccesorio(resultSet.getString("MontoIVACuota"));
					return esquemaAccesoriosBean;
				}
			});

			return matches;
	}

	public List<EsquemaOtrosAccesoriosBean> listaDesgloseAccSim(int tipoLista, EsquemaOtrosAccesoriosBean esquemaAccesoriosBean) {
		List<EsquemaOtrosAccesoriosBean> lista= null;
		try {
			String query = "CALL DETALLEACCESORIOSLIS (?,?,?,?,?,	?,?,?,?,?);";
			Object[] parametros = {
					Constantes.ENTERO_CERO,
					esquemaAccesoriosBean.getCreditoID(),
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"EsquemaOtrosAccesoriosDAO.listaDesgloseAccSim",
					Constantes.ENTERO_CERO,
					esquemaAccesoriosBean.getNumTransacSim()};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL DETALLEACCESORIOSLIS (" + Arrays.toString(parametros) +")");
			List<EsquemaOtrosAccesoriosBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EsquemaOtrosAccesoriosBean resultado = new EsquemaOtrosAccesoriosBean();
					resultado.setAmortizacionID(resultSet.getString("AmortizacionID"));
					resultado.setMontoCuota(resultSet.getString("MontoCuota"));
					resultado.setMontoIVACuota(resultSet.getString("MontoIVACuota"));
					resultado.setMontoIntCuota(resultSet.getString("MontoIntCuota"));
					resultado.setMontoIVAIntCuota(resultSet.getString("MontoIVAIntCuota"));
					resultado.setMontoAccesorio(resultSet.getString("MontoAccesorio"));
					resultado.setMontoIVAAccesorio(resultSet.getString("MontoIVAAccesorio"));
					resultado.setMontoInteres(resultSet.getString("MontoInteres"));
					resultado.setMontoIVAInteres(resultSet.getString("MontoIVAInteres"));
					resultado.setContadorAccesorios(resultSet.getString("ContadorAccesorios"));
					resultado.setEncabezadoLista(resultSet.getString("EncabezadoLista"));
					resultado.setNumAmortizacion(resultSet.getString("NumAmortizacion"));
					resultado.setGeneraInteres(resultSet.getString("GeneraInteres"));

					return resultado;
				}
			});
			lista = matches;
		} catch(Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en lista de accesorios", e);
		}
		return lista;
	}
}