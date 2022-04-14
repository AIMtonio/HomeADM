package tesoreria.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import cuentas.bean.CuentasAhoBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import tesoreria.bean.CuentaNostroBean;
import ventanilla.bean.ChequesEmitidosBean;


public class CuentaNostroDAO extends BaseDAO{
  public CuentaNostroDAO(){
	  super();
  }
  private final static String salidaPantalla = "S";

  public MensajeTransaccionBean altaCuentaNostro(final CuentaNostroBean cuentaNostro) {
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
							String query = "call CUENTASAHOTESOALT(?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?);";
							String saldo = cuentaNostro.getSaldo().trim().replaceAll(",","").replaceAll("\\$","");
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(cuentaNostro.getCuentaAhoID()));
								sentenciaStore.setInt("Par_InstitucionID", Utileria.convierteEntero(cuentaNostro.getInstitucionID()));
								sentenciaStore.setString("Par_SucursalInstit",cuentaNostro.getSucursalInstit());
								sentenciaStore.setString("Par_NumCtaInstit",cuentaNostro.getNumCtaInstit());
								sentenciaStore.setString("Par_CueClave",cuentaNostro.getCuentaClabe());

								sentenciaStore.setString("Par_Chequera",cuentaNostro.getChequera());
								sentenciaStore.setString("Par_CuentaCompletaID",cuentaNostro.getCuentaCompletaID()); //se va a modificar para que no exista
								sentenciaStore.setInt("Par_CentroCostoID", Utileria.convierteEntero(cuentaNostro.getCentroCostoID()));
								sentenciaStore.setDouble("Par_Saldo", Utileria.convierteDoble(saldo));
								sentenciaStore.setString("Par_Principal", cuentaNostro.getPrincipal());

								sentenciaStore.setInt("Par_FolioUtilizar", Utileria.convierteEntero(cuentaNostro.getFolioUtilizar()));
								sentenciaStore.setString("Par_RutaCheque", cuentaNostro.getRutaCheque());
								sentenciaStore.setString("Par_SobregirarSaldo", cuentaNostro.getSobregirarSaldo());
								sentenciaStore.setString("Par_TipoChequera", cuentaNostro.getTipoChequera());
								sentenciaStore.setInt("Par_FolioUtilizarEstan", Utileria.convierteEntero(cuentaNostro.getFolioUtilizarEstan()));
								sentenciaStore.setString("Par_RutaChequeEstan", cuentaNostro.getRutaChequeEstan());

								sentenciaStore.setString("Par_NumConvenio", cuentaNostro.getNumConvenio());//Parametros convenio
								sentenciaStore.setString("Par_DescConvenio", cuentaNostro.getDescConvenio());

								sentenciaStore.setString("Par_ProtecOrdenPago", cuentaNostro.getProtecOrdenPago());//parametro proteccion ordenes de pago
								sentenciaStore.setString("Par_AlgClaveRetiro",cuentaNostro.getAlgClaveRetiro());
								sentenciaStore.setInt("Par_VigClaveRetiro", Utileria.convierteEntero(cuentaNostro.getVigClaveRetiro()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID","CuentaNostroDAO.altaCuentaNostro");
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
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CuentaNostroDAO.AltaCuentaBancaria");
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
						throw new Exception(Constantes.MSG_ERROR + " .CuentaNostroDAO.AltaCuentaBancaria");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al dar de alta la cuenta bancaria" + e);
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

  /*modificacion de cuenta nostro*/
  public MensajeTransaccionBean modificarCuentaNostro(final CuentaNostroBean cuentaNostro, final int tipoActualizacion) {
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

							String query = "call CUENTASAHOTESOACT(?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_SucursalInstit", cuentaNostro.getSucursalInstit());
								sentenciaStore.setString("Par_Chequera", cuentaNostro.getChequera());
								sentenciaStore.setInt("Par_CentroCostoID",Utileria.convierteEntero(cuentaNostro.getCentroCostoID()));
								sentenciaStore.setString("Par_CuentaCompletaID",cuentaNostro.getCuentaCompletaID());	//se va a modificar para que no exista
								sentenciaStore.setString("Par_Principal",cuentaNostro.getPrincipal());

								sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(cuentaNostro.getInstitucionID()));
								sentenciaStore.setString("Par_NumCtaInstit",cuentaNostro.getNumCtaInstit()); 	//se va a modificar para que no exista
								sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(cuentaNostro.getCuentaAhoID()));
								sentenciaStore.setInt("Par_FolioUtilizar", Utileria.convierteEntero(cuentaNostro.getFolioUtilizar()));
								sentenciaStore.setString("Par_RutaCheque", cuentaNostro.getRutaCheque());

								sentenciaStore.setString("Par_SobregirarSaldo", cuentaNostro.getSobregirarSaldo());
								sentenciaStore.setString("Par_TipoChequera", cuentaNostro.getTipoChequera());
								sentenciaStore.setInt("Par_FolioUtilizarEstan", Utileria.convierteEntero(cuentaNostro.getFolioUtilizarEstan()));
								sentenciaStore.setString("Par_RutaChequeEstan", cuentaNostro.getRutaChequeEstan());

								  //Parametros de OutPut
								sentenciaStore.setInt("Par_TipoActualiza",tipoActualizacion);

								sentenciaStore.setString("Par_NumConvenio", cuentaNostro.getNumConvenio());//Parametros convenio
								sentenciaStore.setString("Par_DescConvenio", cuentaNostro.getDescConvenio());
								sentenciaStore.setString("Par_ProtecOrdenPago", cuentaNostro.getProtecOrdenPago());//parametro proteccion ordenes de pago
								sentenciaStore.setString("Par_AlgClaveRetiro",cuentaNostro.getAlgClaveRetiro());
								sentenciaStore.setInt("Par_VigClaveRetiro", Utileria.convierteEntero(cuentaNostro.getVigClaveRetiro()));

							    sentenciaStore.setString("Par_Salida",salidaPantalla);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID","CuentaNostroDAO.modificarCuentaNostro");
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
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CuentaNostroDAO.ModificarCuentaBancaria");
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
						throw new Exception(Constantes.MSG_ERROR + " .CuentaNostroDAO.ModificarCuentaBancaria");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Modificar la Cuenta Bancaria" + e);
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

  /*Baja de cuenta nostro*/
	public MensajeTransaccionBean bajaCuentaNostro(final CuentaNostroBean cuentaNostro) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CUENTASAHOTESOBAJ(?,?,?, ?,?,?, ?,?,?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(cuentaNostro.getCuentaAhoID()));
									sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(cuentaNostro.getInstitucionID()));
									sentenciaStore.setString("Par_NumCtaInstit",cuentaNostro.getNumCtaInstit()); 	//se va a modificar para que no exista

								    sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","CuentaNostroDAO.bajaCuentaNostro");
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							}
							,new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();

									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningún Resultado.");
									}
									return mensajeTransaccion;
								}// public

							}// CallableStatementCallback
							);


						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception("Fallo. El Procedimiento no Regreso Ningún Resultado.");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}


					} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Baja de Cuentas Nostro.", e);
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();

						}
						return mensajeBean;
					}
				});

				return mensaje;
			}// fin




  /* Consulta si ya existe cuentaNostro*/

	public CuentaNostroBean consultaExisteCuenta(CuentaNostroBean cuentaNostro, int tipoConsulta){
		String query = "call CUENTASAHOTESOCON(?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				cuentaNostro.getInstitucionID(),
				Constantes.ENTERO_CERO,
				cuentaNostro.getNumCtaInstit(),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CuentaNostroDAO.consultaExisteCuenta",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOTESOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				CuentaNostroBean cuentaNostro = new CuentaNostroBean();
				cuentaNostro.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
				cuentaNostro.setInstitucionID(resultSet.getString("InstitucionID"));
				cuentaNostro.setSucursalInstit(resultSet.getString("SucursalInstit"));
				cuentaNostro.setNumCtaInstit(resultSet.getString("NumCtaInstit"));
				cuentaNostro.setCuentaClabe(resultSet.getString("CueClave"));
				cuentaNostro.setChequera(resultSet.getString("Chequera"));
				cuentaNostro.setCuentaCompletaID(resultSet.getString("CuentaCompletaID"));
				cuentaNostro.setCentroCostoID(resultSet.getString("CentroCostoID"));
				cuentaNostro.setSaldo(resultSet.getString("Saldo"));
				cuentaNostro.setPrincipal(resultSet.getString("Principal"));
				cuentaNostro.setEstatus(resultSet.getString("Estatus"));
				cuentaNostro.setFolioUtilizar(resultSet.getString("FolioUtilizar"));
				cuentaNostro.setRutaCheque(resultSet.getString("RutaCheque"));
				cuentaNostro.setSobregirarSaldo(resultSet.getString("SobregirarSaldo"));
				cuentaNostro.setTipoChequera(resultSet.getString("TipoChequera"));
				cuentaNostro.setFolioUtilizarEstan(resultSet.getString("FolioUtilizarEstan"));
				cuentaNostro.setRutaChequeEstan(resultSet.getString("RutaChequeEstan"));
				cuentaNostro.setNumConvenio(resultSet.getString("NumConvenio"));
				cuentaNostro.setDescConvenio(resultSet.getString("DescConvenio"));
				cuentaNostro.setProtecOrdenPago(resultSet.getString("ProtecOrdenPago"));
				cuentaNostro.setAlgClaveRetiro(resultSet.getString("AlgClaveRetiro"));
				cuentaNostro.setVigClaveRetiro(resultSet.getString("VigClaveRetiro"));
				return cuentaNostro;
			}
		});
		return matches.size() > 0 ? (CuentaNostroBean) matches.get(0) : null;
	}

 //Consulta Folio de institucion
	public CuentaNostroBean consultaFolioInstit(CuentaNostroBean cuentaNostro, int tipoConsulta){
		String query = "call CUENTASAHOTESOCON(?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				cuentaNostro.getInstitucionID(),
				Constantes.ENTERO_CERO,
				cuentaNostro.getNumCtaInstit(),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CuentaNostroDAO.consultaFolioInstit",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOTESOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				CuentaNostroBean cuentaNostro = new CuentaNostroBean();
				cuentaNostro.setCuentaClabe(resultSet.getString("CueClave"));

				return cuentaNostro;
			}
		});
		return matches.size() > 0 ? (CuentaNostroBean) matches.get(0) : null;
	}

	public CuentaNostroBean consultaSaldo(CuentaNostroBean cuentaNostro, int tipoConsulta){
		CuentaNostroBean consultaCuentaNostroBean = new CuentaNostroBean();
		try{
			String query = "call CUENTASAHOTESOCON(?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
				Object[] parametros = {
						cuentaNostro.getInstitucionID(),
						Constantes.ENTERO_CERO,
						cuentaNostro.getNumCtaInstit(),
						tipoConsulta,
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.STRING_VACIO,

						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"CuentaNostroDAO.consultaSaldo",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO
						};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOTESOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						CuentaNostroBean cuentaNostro = new CuentaNostroBean();
						cuentaNostro.setSaldo(resultSet.getString("Saldo"));
						return cuentaNostro;
					}
				});
				consultaCuentaNostroBean= matches.size() > 0 ? (CuentaNostroBean) matches.get(0) : null;

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de saldo", e);
		}
		return consultaCuentaNostroBean;
	}

	public CuentaNostroBean consultaEstatusNumCtaInstitucio(CuentaNostroBean cuentaNostro, int tipoConsulta){
		CuentaNostroBean consultaCuentaNostroBean = new CuentaNostroBean();
		try{
			String query = "call CUENTASAHOTESOCON(?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
				Object[] parametros = {
						cuentaNostro.getInstitucionID(),
						Constantes.ENTERO_CERO,
						cuentaNostro.getNumCtaInstit(),
						tipoConsulta,
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.STRING_VACIO,

						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"CuentaNostroDAO.consultaSaldo",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO
						};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOTESOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						CuentaNostroBean cuentaNostro = new CuentaNostroBean();
						cuentaNostro.setEstatus(resultSet.getString("Estatus"));
						return cuentaNostro;
					}
				});
				consultaCuentaNostroBean= matches.size() > 0 ? (CuentaNostroBean) matches.get(0) : null;

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de status", e);
		}
		return consultaCuentaNostroBean;
	}

	public List listaNumCtaInstit(CuentaNostroBean cuentaNostroBean, int tipoLista){
		String query = "call CUENTASAHOTESOLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
					Constantes.STRING_VACIO,
				    Utileria.convierteEntero(cuentaNostroBean.getInstitucionID()) ,
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"TesoMovsConciliaDAO.listaTesoMovsConc",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOTESOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentaNostroBean cuentaNostroBean = new CuentaNostroBean();
				cuentaNostroBean.setNumCtaInstit(resultSet.getString("NumCtaInstit"));
				cuentaNostroBean.setSucursalInstit(resultSet.getString("SucursalInstit"));

				return cuentaNostroBean;
			}
		});
		return matches;
	}

	public List listaNumCtaInstitNostro(CuentaNostroBean cuentaNostroBean, int tipoLista){
		String query = "call CUENTASAHOTESOLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
					cuentaNostroBean.getNumCtaInstit(),
				    Utileria.convierteEntero(cuentaNostroBean.getInstitucionID()) ,
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"TesoMovsConciliaDAO.listaNumCtaInstitNostro",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOTESOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentaNostroBean cuentaNostroBean = new CuentaNostroBean();
				cuentaNostroBean.setNumCtaInstit(resultSet.getString("NumCtaInstit"));
				cuentaNostroBean.setSucursalInstit(resultSet.getString("SucursalInstit"));

				return cuentaNostroBean;
			}
		});
		return matches;
	}


	public List listaNumCtaInstitFond(CuentaNostroBean cuentaNostroBean, int tipoLista){
		String query = "call CUENTASAHOTESOLIS(?,?,?,?,?,?,?,?,?,?);";

		Object[] parametros = {
					cuentaNostroBean.getNumCtaInstit(),
				    Utileria.convierteEntero(cuentaNostroBean.getInstitucionID()) ,
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"TesoMovsConciliaDAO.listaTesoMovsConc",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOTESOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentaNostroBean cuentaNostroBean = new CuentaNostroBean();
				cuentaNostroBean.setNumCtaInstit(resultSet.getString("NumCtaInstit"));
				cuentaNostroBean.setSucursalInstit(resultSet.getString("SucursalInstit"));

				return cuentaNostroBean;
			}
		});
		return matches;
	}

	 //Consulta Folio de institucion
		public CuentaNostroBean consultaUltimoFolio(CuentaNostroBean cuentaNostro, int tipoConsulta){
			String query = "call CUENTASAHOTESOCON(?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
					cuentaNostro.getInstitucionID(),
					Constantes.ENTERO_CERO,
					cuentaNostro.getNumCtaInstit(),
					tipoConsulta,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.STRING_VACIO,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CuentaNostroDAO.ConsultaUltimoFolio",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOTESOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CuentaNostroBean cuentaNostro = new CuentaNostroBean();
					cuentaNostro.setFolioUtilizar(resultSet.getString("FolioUtilizar"));
					cuentaNostro.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
					cuentaNostro.setCuentaClabe(resultSet.getString("CueClave"));
					cuentaNostro.setRutaCheque(resultSet.getString("RutaCheque"));

					return cuentaNostro;
				}
			});
			return matches.size() > 0 ? (CuentaNostroBean) matches.get(0) : null;
		}

		 //Consulta Ruta del Cheque
			public CuentaNostroBean consultaRutaCheque(CuentaNostroBean cuentaNostro, int tipoConsulta){
				String query = "call CUENTASAHOTESOCON(?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
				Object[] parametros = {
						cuentaNostro.getInstitucionID(),
						Constantes.ENTERO_CERO,
						cuentaNostro.getNumCtaInstit(),
						tipoConsulta,
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						cuentaNostro.getTipoChequera(),

						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"CuentaNostroDAO.ConsultaRutaCheque",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO
						};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOTESOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						CuentaNostroBean cuentaNostro = new CuentaNostroBean();
						cuentaNostro.setRutaCheque(resultSet.getString("RutaCheque"));
						cuentaNostro.setCuentaAhoID(resultSet.getString("CuentaAhoID"));

						return cuentaNostro;
					}
				});
				return matches.size() > 0 ? (CuentaNostroBean) matches.get(0) : null;
			}


			 //Consulta Ruta del Cheque
				public CuentaNostroBean consultaRutaChequeEstan(CuentaNostroBean cuentaNostro, int tipoConsulta){
					String query = "call CUENTASAHOTESOCON(?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
					Object[] parametros = {
							cuentaNostro.getInstitucionID(),
							Constantes.ENTERO_CERO,
							cuentaNostro.getNumCtaInstit(),
							tipoConsulta,
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							cuentaNostro.getTipoChequera(),

							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							"CuentaNostroDAO.ConsultaRutaCheque",
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOTESOCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							CuentaNostroBean cuentaNostro = new CuentaNostroBean();
							cuentaNostro.setRutaChequeEstan(resultSet.getString("RutaChequeEstan"));
							cuentaNostro.setCuentaAhoID(resultSet.getString("CuentaAhoID"));

							return cuentaNostro;
						}
					});
					return matches.size() > 0 ? (CuentaNostroBean) matches.get(0) : null;
				}

			 //Consulta Folio de institucion
			public CuentaNostroBean consultaFolioEmitido(CuentaNostroBean cuentaNostro, int tipoConsulta){
				String query = "call CUENTASAHOTESOCON(?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
				Object[] parametros = {
						cuentaNostro.getInstitucionID(),
						Constantes.ENTERO_CERO,
						cuentaNostro.getNumCtaInstit(),
						tipoConsulta,
						cuentaNostro.getCuentaClabe(),
						Constantes.ENTERO_CERO,
						cuentaNostro.getTipoChequera(),

						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"CuentaNostroDAO.consultaFolioEmitido",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO
						};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOTESOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

						CuentaNostroBean cuentaNostro = new CuentaNostroBean();
						cuentaNostro.setFolioEmitido(resultSet.getString("NumeroCheque"));

						return cuentaNostro;
					}
				});
				return matches.size() > 0 ? (CuentaNostroBean) matches.get(0) : null;
			}
//fin de la consulta

			 //Consulta Tipo Chequera
			public List  listaTipoChequera(CuentaNostroBean cuentaNostro, int tipoLista){
				String query = "call CUENTASAHOTESOCON(?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
				Object[] parametros = {
						cuentaNostro.getInstitucionID(),
						Constantes.ENTERO_CERO,
						cuentaNostro.getNumCtaInstit(),
						tipoLista,
						cuentaNostro.getCuentaClabe(),
						Constantes.ENTERO_CERO,
						Constantes.STRING_VACIO,

						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"CuentaNostroDAO.consultaTipoChequera",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO
						};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOTESOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

						CuentaNostroBean cuentaNostro = new CuentaNostroBean();
						cuentaNostro.setTipoChequera(resultSet.getString("TipoChequera"));
						cuentaNostro.setDescripTipoChe(resultSet.getString("DescripTipoChe"));

						return cuentaNostro;
					}
				});
				return matches;
			}




			 //Consulta Folio de institucion
			public CuentaNostroBean consultaChequeEmitido(CuentaNostroBean cuentaNostro, int tipoConsulta){
				String query = "call CUENTASAHOTESOCON(?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
				Object[] parametros = {
						cuentaNostro.getInstitucionID(),
						Constantes.ENTERO_CERO,
						cuentaNostro.getNumCtaInstit(),
						tipoConsulta,
						cuentaNostro.getCuentaClabe(),
						Constantes.ENTERO_CERO,
						cuentaNostro.getTipoChequera(),

						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"CuentaNostroDAO.consultaFolioEmitido",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO
						};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOTESOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

						CuentaNostroBean cuentaNostro = new CuentaNostroBean();
						cuentaNostro.setBeneficiarioCan(resultSet.getString("Beneficiario"));
						cuentaNostro.setMonto(resultSet.getString("Monto"));
						cuentaNostro.setConcepto(resultSet.getString("Concepto"));
						cuentaNostro.setFechaEmision(resultSet.getString("FechaEmision"));
						cuentaNostro.setEmitidoEn(resultSet.getString("EmitidoEn"));

						return cuentaNostro;

					}
				});
				return matches.size() > 0 ? (CuentaNostroBean) matches.get(0) : null;
			}
//fin de la consulta



}
