package bancaMovil.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
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

import bancaMovil.bean.BAMCuentasOrigenBean;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;


public class BAMCuentasOrigenDAO extends BaseDAO{

	public BAMCuentasOrigenDAO() {
		super();
	}
	// ------------------ Propiedades y Atributos ------------------------------------------
	ParametrosSesionBean parametrosSesionBean;

	/* Lista de BAMCuentasOrigen por ID */
	public List listaPrincipal(BAMCuentasOrigenBean cuentasOrigenBean, int tipoLista) {
		List matches = new ArrayList();
		try {
			//Query con el Store Procedure
			String query = "call BANCUENTASCARGOLIS(?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	cuentasOrigenBean.getClienteID(),
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BANCUENTASCARGOLIS(" + Arrays.toString(parametros) + ")");

			matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					BAMCuentasOrigenBean cuentasOrigenBean = new BAMCuentasOrigenBean();


					cuentasOrigenBean.setClienteID(String.valueOf(resultSet.getInt("ClienteID")));
					cuentasOrigenBean.setCuentaAhoID(String.valueOf(resultSet.getLong("CuentaAhoID")));
					cuentasOrigenBean.setEstatus(resultSet.getString("Estatus"));
					cuentasOrigenBean.setFechaApertura(String.valueOf(resultSet.getDate("FechaApertura")));
					cuentasOrigenBean.setDescripcion(resultSet.getString("Descripcion"));
					cuentasOrigenBean.setNombreSucursal(resultSet.getString("NombreSucurs"));

					return cuentasOrigenBean;
				}
			});
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			loggerSAFI.error(e.getMessage());
		}

		return matches;
	}

	/* Lista de BAMCuentasOrigen por ID */
	public List listaFiltroCuentas(BAMCuentasOrigenBean cuentasOrigenBean, int tipoLista) {
		//Query con el Store Procedure

		String query = "call BANCUENTASCARGOLIS(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	cuentasOrigenBean.getClienteID(),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				1,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO};
		loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BANCUENTASCARGOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				BAMCuentasOrigenBean cuentasOrigenBean = new BAMCuentasOrigenBean();
				cuentasOrigenBean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
				cuentasOrigenBean.setDescripcion(resultSet.getString("Descripcion"));
				return cuentasOrigenBean;
			}
		});

		return matches;
	}

	///Lista cuentas origen para WS
	public List listaCuentasCargoWS(int tipoLista,int clienteID){

		List cuentasUsuario = null;
		try{
			String query = "call BANCUENTASCARGOLIS(?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {clienteID,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					tipoLista,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"BamSPEI.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BANCUENTASCARGOLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
					BAMCuentasOrigenBean  cuentas= new BAMCuentasOrigenBean();
					cuentas.setClienteID(resultSet.getString("ClienteID"));
					cuentas.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
					cuentas.setDescripcion(resultSet.getString("Descripcion"));
					cuentas.setSaldoDispon(resultSet.getString("SaldoDispon"));
					return cuentas;
				}
			});

			cuentasUsuario = matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la lista de BAMCUENTAS-CARGO para WS", e);
		}

		return cuentasUsuario;
	}// fin de lista para WS

	/* Consuta Cuentas Origen por Llave Principal*/
	public BAMCuentasOrigenBean consultaPrincipal(long cuentaAhoID, int tipoConsulta) {
		BAMCuentasOrigenBean cuentasOrigenBean = null;
		try{
			//Query con el Store Procedure
			String query = "call BANCUENTASCARGOCON(?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	cuentaAhoID,
					tipoConsulta,
					Constantes.ENTERO_CERO,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ClienteDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BANCUENTASCARGOCON(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					BAMCuentasOrigenBean cuentaOrigen = new BAMCuentasOrigenBean();
					cuentaOrigen.setClienteID(resultSet.getString("ClienteID"));
					cuentaOrigen.setTipoCuentaID(resultSet.getString("TipoCuentaID"));
					cuentaOrigen.setFechaApertura(resultSet.getString("FechaApertura"));
					cuentaOrigen.setSucursalID(resultSet.getString("SucursalID"));
					cuentaOrigen.setDescripcion(resultSet.getString("Descripcion"));
					cuentaOrigen.setNombreSucursal(resultSet.getString("NombreSucurs"));

					return cuentaOrigen;
				}
			});
			cuentasOrigenBean= matches.size() > 0 ? (BAMCuentasOrigenBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+/*parametrosAuditoriaBean.getOrigenDatos()+"-"+*/"error en la consulta de CuentasOrigen", e);
		}
		return cuentasOrigenBean;
	}


	public BAMCuentasOrigenBean consultaVerificacionCuenta(long cuentaAhoID, int tipoConsulta, int clienteID) {
		BAMCuentasOrigenBean cuentasOrigenBean = null;
		try{
			//Query con el Store Procedure
			String query = "call BANCUENTASCARGOCON(?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	cuentaAhoID,
					tipoConsulta,
					clienteID,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ClienteDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BANCUENTASCARGOCON(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					BAMCuentasOrigenBean cuentaOrigen = new BAMCuentasOrigenBean();

					cuentaOrigen.setClienteID(resultSet.getString("ClienteID"));
					cuentaOrigen.setTipoCuentaID(resultSet.getString("TipoCuentaID"));
					cuentaOrigen.setFechaApertura(resultSet.getString("FechaApertura"));
					cuentaOrigen.setSucursalID(resultSet.getString("SucursalID"));
					return cuentaOrigen;
				}
			});
			cuentasOrigenBean= matches.size() > 0 ? (BAMCuentasOrigenBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
		}
		return cuentasOrigenBean;
	}

	public MensajeTransaccionBean grabaListaCuentasOrigen(final BAMCuentasOrigenBean cuentasOrigenBean,
			final List listaCuentasOrigen) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					BAMCuentasOrigenBean montoBean;

					mensajeBean = bajaCuentasOrigen(cuentasOrigenBean,2);
					for(int i=0; i<listaCuentasOrigen.size(); i++){
						montoBean = (BAMCuentasOrigenBean)listaCuentasOrigen.get(i);
						mensajeBean = altaCuentasOrigen(montoBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Cuentas Origen Actualizadas correctamente");
					mensajeBean.setNombreControl("clienteID");
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en grabacion de listas de cuentas origen", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// ------------------ Transacciones ------------------------------------------
	public MensajeTransaccionBean altaCuentasOrigen(final BAMCuentasOrigenBean cuentasOrigen) {
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
									String query = "call BANCUENTASCARGOALT(?,?,?,?,?,?,?,?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(cuentasOrigen.getClienteID()));
									sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(cuentasOrigen.getCuentaAhoID()));

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
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

									loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .TiposCuentaDAO.altaTipoCuentaDAO");
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
							throw new Exception(Constantes.MSG_ERROR + " .BanTiposCuentaDAO.altaBanTipoCuentaDAO");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Registro de Tipo de Cuenta" + e);
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

	public MensajeTransaccionBean bajaCuentasOrigen(final BAMCuentasOrigenBean cuentasOrigen,final int consulta) {
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

									String query = "call BANCUENTASCARGOBAJ(" +
											"?,?,?," +
											"?,?,?," +
											"?,?,?,?,?,?,?);";//parametros de auditoria

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(cuentasOrigen.getClienteID()));
									sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(cuentasOrigen.getCuentaAhoID()));
									sentenciaStore.setInt("Par_NumBaja",consulta);

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//parametros de auditoria
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
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
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"),parametrosSesionBean.getNomCortoInstitucion()));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .BAMCuentasOrigenDAO.bajaCuentasOrigen");
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
						throw new Exception(Constantes.MSG_ERROR + " .BAMCuentasOrigenDAO.bajaCuentasOrigen");
					}else if(mensajeBean.getNumero()!=0){
						if(mensajeBean.getNumero()==50){
							loggerSAFI.error(this.getClass()+" - "+"Error en BAJA de Cuentas Origen: " + mensajeBean.getDescripcion());
						} else {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
				} catch (Exception e) {
					loggerSAFI.error(this.getClass()+" - "+"Error en el baja de Cuentas Origen" + e.getMessage());
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

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}





}
