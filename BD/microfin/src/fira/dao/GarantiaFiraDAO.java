package fira.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import contabilidad.bean.PolizaBean;
import contabilidad.dao.PolizaDAO;
import fira.bean.GarantiaFiraBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class GarantiaFiraDAO extends BaseDAO {

	public GarantiaFiraDAO(){
		super();
	}
	private final static String salidaPantalla = "S";
	public String conceptoAplicacionGtiaFira="909"; //tabla CONCEPTOSCONTA
	public String conceptoAplicacionGtiaFiraDes="APLICACION GARANTIA FIRA"; //tabla CONCEPTOSCONTA
	String automatico = "A"; // indica que se trata de una poliza automatica
	PolizaDAO polizaDAO = new PolizaDAO();


	/* Procesar los creditos con garantia sin fondeo */
	public MensajeTransaccionBean procesoCredConGarSinFondeo(final GarantiaFiraBean garantiaFiraBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure

			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CREDITOGARSINFONDEOPRO(?,?,?,?,?, ?,?,?,?,?, ?,?,?);";


								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(garantiaFiraBean.getCreditoID()));
								sentenciaStore.setInt("Par_TipoGarantia", Utileria.convierteEntero(garantiaFiraBean.getTipoGarantiaID()));
								sentenciaStore.setString("Par_Cancelado", garantiaFiraBean.getEsCancelado());


   								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																										DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){

									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el proceso de garantias FEGA y FONAGA", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	public MensajeTransaccionBean registraCreditosConGarSinFondeo(final GarantiaFiraBean garantiaFiraBean,final List listaCreditos,int tipoTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {


					for(int pos = 0; pos < listaCreditos.size() ; pos++){

						GarantiaFiraBean creditoGar = (GarantiaFiraBean) listaCreditos.get(pos);

						mensajeBean = procesoCredConGarSinFondeo(creditoGar);
						if(mensajeBean.getNumero() != 0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}

					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Operación Realizada Exitosamente");

				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al registrar los creditos sin fondeo", e);
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

	public MensajeTransaccionBean aplicacionGtiaFira(final GarantiaFiraBean garantiaFiraBean,int tipoTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try {
			transaccionDAO.generaNumeroTransaccion();
			final PolizaBean polizaBean = new PolizaBean();
			polizaBean.setConceptoID(conceptoAplicacionGtiaFira);
			polizaBean.setConcepto(conceptoAplicacionGtiaFiraDes);
			int	contador  = 0;
			// no se a dado de alta la poliza se agrega una poliza nueva

			while(contador <= PolizaBean.numIntentosGeneraPoliza){
				contador ++;
				polizaDAO.generaPolizaIDGenerico(polizaBean,parametrosAuditoriaBean.getNumeroTransaccion());
				if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0){
					break;
				}
			}

			if (Utileria.convierteEntero(polizaBean.getPolizaID()) >0){
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						String poliza = polizaBean.getPolizaID();
						try {
							garantiaFiraBean.setPolizaID(poliza);
							mensajeBean = aplicarGarantiasFira(garantiaFiraBean, parametrosAuditoriaBean.getNumeroTransaccion());

							if(mensajeBean.getNumero() != 0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en aplicación de garantías FIRA", e);
						}
						return mensajeBean;
					}
				});

				/* Baja de Poliza en caso de que haya ocurrido un error */
				if (mensaje.getNumero() != 0) {
					try {
						PolizaBean bajaPolizaBean = new PolizaBean();
						bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
						bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
						bajaPolizaBean.setNumErrPol(mensaje.getNumero() + "");
						bajaPolizaBean.setErrMenPol(mensaje.getDescripcion());
						bajaPolizaBean.setDescProceso("GarantiaFira.aplicacionGtiaFira");
						bajaPolizaBean.setPolizaID(garantiaFiraBean.getPolizaID());
						MensajeTransaccionBean mensajeBaja = new MensajeTransaccionBean();
						mensajeBaja = polizaDAO.bajaPoliza(bajaPolizaBean);
						loggerSAFI.error(" Numero Error:" + mensajeBaja.getNumero() + " Mensaje: " + mensajeBaja.getDescripcion());
					} catch (Exception ex) {
						ex.printStackTrace();
					}
				}
				/* Fin Baja de la Poliza Contable*/
			}else{
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}


		}catch(Exception ex){
			mensaje.setNumero(999);
			mensaje.setDescripcion("Error al Realizar Aplicación de garantías FIRA.");
			ex.printStackTrace();
		}
		return mensaje;
	}


	public MensajeTransaccionBean aplicarGarantiasFira(final GarantiaFiraBean garantiaFiraBean,final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call APLIGARANAGROPRO("
											+ "?,?,?,?,?,		"
											+ "?,?,?,?,?,		"
											+ "?,?,?,?,?,		"
											+ "?,?,?,?,?,		"
											+ "?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(garantiaFiraBean.getCreditoID()));
									sentenciaStore.setDouble("Par_MontoTotCredSinIVA", Utileria.convierteDoble(garantiaFiraBean.getMontoTotCredSinIVA()));
									sentenciaStore.setDouble("Par_MontoGtia",  Utileria.convierteDoble(garantiaFiraBean.getGarantiaAplicar()));
									sentenciaStore.setDouble("Par_MontoProgEsp",Constantes.DOUBLE_VACIO);
									sentenciaStore.setInt("Par_TipoGarantiaFira", Utileria.convierteEntero(garantiaFiraBean.getTipoGarantiaID()));

									sentenciaStore.setInt("Par_TipoProgEspFira", Utileria.convierteEntero(garantiaFiraBean.getProgEspecial()));
									sentenciaStore.setString("Par_EstatusGarantia", garantiaFiraBean.getEstatusGarantia());
									sentenciaStore.setDouble("Par_PorcentajeGtia", Utileria.convierteDoble(garantiaFiraBean.getPorcentajeGtia()));
									sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(garantiaFiraBean.getMonedaID()));
									sentenciaStore.setInt("Par_Poliza",Utileria.convierteEntero(garantiaFiraBean.getPolizaID()));

									sentenciaStore.setLong("Par_CreditoContFondeador",Utileria.convierteLong(garantiaFiraBean.getCreditoContFondeador()));
									sentenciaStore.setString("Par_Observacion",garantiaFiraBean.getObservacion());
									sentenciaStore.setInt("Par_UsuarioID", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setString("Par_OrigenPago", Constantes.ORIGEN_PAGO_CARGOCTA);

									// Datos FIRA
									sentenciaStore.setLong("Par_AcreditadoIDFIRA", Utileria.convierteLong(garantiaFiraBean.getAcreditadoIDFIRA()));

									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
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
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));


									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .GarantiaFiraDAO.aplicarGarantiasFira");
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
							throw new Exception(Constantes.MSG_ERROR + " .GarantiaFiraDAO.aplicarGarantiasFira");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al Realizar la aplicacion de las garantias.", e);
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


	public MensajeTransaccionBean cancelaGarantiasFira(final GarantiaFiraBean garantiaFiraBean,final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure


			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CREDITOSACT(?,?,?,?,?,   ?,?,?,?,?," +
																"?,?,?,?,?,	  ?,?,?,?,?," +
																"?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(garantiaFiraBean.getCreditoID()));
								sentenciaStore.setLong("Par_NumTransSim",Constantes.ENTERO_CERO);
								sentenciaStore.setDate("Par_FechaAutoriza",OperacionesFechas.conversionStrDate(Constantes.FECHA_VACIA));
								sentenciaStore.setInt("Par_UsuarioAutoriza",Constantes.ENTERO_CERO);
								sentenciaStore.setString("Par_TipoPrepago",Constantes.STRING_VACIO);

								sentenciaStore.setInt("Par_NumAct",tipoActualizacion);
								sentenciaStore.setDate("Par_FechaInicio",OperacionesFechas.conversionStrDate(Constantes.FECHA_VACIA));
								sentenciaStore.setDate("Par_FechaVencim",OperacionesFechas.conversionStrDate(Constantes.FECHA_VACIA));
								sentenciaStore.setDouble("Par_ValorCAT",Constantes.ENTERO_CERO);
								sentenciaStore.setDouble("Par_MontoRetDes",Constantes.ENTERO_CERO);
								sentenciaStore.setDouble("Par_FolioDisper",Constantes.ENTERO_CERO);
								sentenciaStore.setString("Par_TipoDisper",Constantes.STRING_VACIO);
								sentenciaStore.setInt("Par_GrupoID", Constantes.ENTERO_CERO);

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																										DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){

									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en cancelacion de garantia FIRA", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	// consulta para bitacora aplicacion de garantias AGRO
	public GarantiaFiraBean bitacoApliGarAgro(int tipoConsulta,GarantiaFiraBean garantiaFiraBean) {
		GarantiaFiraBean garantias = null;
		try{
			//Query con el Store Procedure
			String query = "call BITACORAAPLIGARCON(?,?,?,  ?,?,?,?,?,?,?);";
			Object[] parametros = {

					garantiaFiraBean.getCreditoID(),
					Constantes.ENTERO_CERO,
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"GarantiaFiraDAO.bitacoApliGarAgro",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "CALL BITACORAAPLIGARCON(  " + Arrays.toString(parametros) + ")");
			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					GarantiaFiraBean gtiaFiraBean = new GarantiaFiraBean();
					gtiaFiraBean.setExisteGtia(resultSet.getString("ExisteGtia"));

					return gtiaFiraBean;

				}
			});
			garantias= matches.size() > 0 ? (GarantiaFiraBean) matches.get(0) : null;
		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de aplicacion de garantías fira.", e);
			e.printStackTrace();
		}
	return garantias;
	}

	// Reporte de Créditos con Afectación de Garantía Periódico
	public List<GarantiaFiraBean> reporteCreditoAfectacionGarantia(final GarantiaFiraBean garantiaFiraBean, final int tipoReporte) {

		List<GarantiaFiraBean> listaGarantias = null;
		//Query con el Store Procedure
		try{
			String query = "CALL CREDITOSAFECTACIONESREP(?,?,?,?,?,"
													   +"?,"
											   		   +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteFecha(garantiaFiraBean.getFechaInicio()),
				Utileria.convierteFecha(garantiaFiraBean.getFechaFin()),
				Utileria.convierteEntero(garantiaFiraBean.getSucursalID()),
				Utileria.convierteLong(garantiaFiraBean.getProductoCreditoID()),
				Utileria.convierteEntero(garantiaFiraBean.getTipoGarantiaID()),
				tipoReporte,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"GarantiaFiraDAO.reporteCreditoAfectacionGarantia",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL CREDITOSAFECTACIONESREP(" + Arrays.toString(parametros) + ")");
			List<GarantiaFiraBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					GarantiaFiraBean garantiaFira = new GarantiaFiraBean();

					garantiaFira.setConsecutivo(resultSet.getString("Consecutivo"));
					garantiaFira.setNombreSucursal(resultSet.getString("NombreSucursal"));
					garantiaFira.setTipoCredito(resultSet.getString("TipoCredito"));
					garantiaFira.setCreditoActivo(resultSet.getString("CreditoActivo"));
					garantiaFira.setCreditoPasivo(resultSet.getString("CreditoPasivo"));

					garantiaFira.setCreditoContigente(resultSet.getString("CreditoContigente"));
					garantiaFira.setCreditoFondeador(resultSet.getString("CreditoFondeador"));
					garantiaFira.setCreditoPasivoContigente(resultSet.getString("CreditoPasivoContigente"));
					garantiaFira.setEstatus(resultSet.getString("Estatus"));
					garantiaFira.setTipoGarantia(resultSet.getString("TipoGarantia"));

					garantiaFira.setNombreCliente(resultSet.getString("NombreCliente"));
					garantiaFira.setFuenteFondeo(resultSet.getString("FuenteFondeo"));
					garantiaFira.setCausaPago(resultSet.getString("CausaPago"));
					garantiaFira.setCadenaProductiva(resultSet.getString("CadenaProductiva"));
					garantiaFira.setMontoGarantia(resultSet.getString("MontoGarantia"));

					garantiaFira.setFechaGarantia(resultSet.getString("FechaGarantia"));
					garantiaFira.setFechaAfectacion(resultSet.getString("FechaAfectacion"));
					garantiaFira.setSaldoCapital(resultSet.getString("SaldoCapital"));
					garantiaFira.setSaldoInteres(resultSet.getString("SaldoInteres"));
					garantiaFira.setMontoTotalCapitalRecuperado(resultSet.getString("MontoTotalCapitalRecuperado"));

					garantiaFira.setMontoTotalInteresRecuperado(resultSet.getString("MontoTotalInteresRecuperado"));
					garantiaFira.setMontoPendienteCapitalRecuperado(resultSet.getString("MontoPendienteCapitalRecuperado"));
					garantiaFira.setMontoPendienteInteresRecuperado(resultSet.getString("MontoPendienteInteresRecuperado"));
					garantiaFira.setSaldoIncobrable(resultSet.getString("SaldoIncobrable"));
					garantiaFira.setTotalRecuperado(resultSet.getString("TotalRecuperado"));

					garantiaFira.setAntiguedad(resultSet.getString("Antiguedad"));

					return garantiaFira;

				}
			});

			listaGarantias = matches;

		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en el Reporte de Créditos con Afectación de Garantía Periódico ", exception);
			listaGarantias = null;
		}

		return listaGarantias;
	}

	public PolizaDAO getPolizaDAO() {
		return polizaDAO;
	}


	public void setPolizaDAO(PolizaDAO polizaDAO) {
		this.polizaDAO = polizaDAO;
	}



}