package tarjetas.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.rmi.RemoteException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import credito.bean.CarCambioFondeoBitBean;

import cliente.bean.ClienteBean;
import cliente.servicio.ClienteServicio;
import soporte.PropiedadesSAFIBean;
import soporte.bean.ParamGeneralesBean;
import soporte.servicio.ParamGeneralesServicio;
import tarjetas.bean.BitacoraEstatusTarDebBean;
import tarjetas.bean.TarjetaDebitoBean;
import tarjetas.servicio.TarjetaDebitoServicio.Enum_Con_ParamGenerales;
import tarjetas.servicio.TarjetaDebitoServicio.Enum_Tra_tarjetaDebito;
import tarjetas.servicio.WsRelacionClienteTarjetaProxy;
import ventanilla.bean.IngresosOperacionesBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class TarjetaDebitoDAO  extends BaseDAO{
	ClienteServicio clienteServicio = null;
	ParamGeneralesServicio paramGeneralesServicio = null;
	int tipoConsultaTD	= 10;
	String conexionEntura = "E";

	public TarjetaDebitoDAO() {
		super();
	}
	public MensajeTransaccionBean alta(int tipoTransaccion,final TarjetaDebitoBean tarjetaDebitoBean) {
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
									String query = "call TARJETADEBITOALT(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);


									sentenciaStore.setInt("Par_LoteDebitoID",Utileria.convierteEntero(tarjetaDebitoBean.getLoteDebitoID()));
									sentenciaStore.setString("Par_FechaRegistro",tarjetaDebitoBean.getFechaRegistro());
									sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(tarjetaDebitoBean.getSucursalID()));
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","TarjetaDebitoDAO");

									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;


								} //public sql exception
							} // new CallableStatementCreator
							,new CallableStatementCallback() {
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
								}// public
							}// CallableStatementCallback
							);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de tarjeta de debito", e);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}//catch
				return mensajeBean;
			} //public Object doInTransaction
		}); //men
		return mensaje;
	}


	public MensajeTransaccionBean insertaLoteTarjeta(int tipoTransaccion,final TarjetaDebitoBean tarjetaDebitoBean) {
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
									String query = "call LOTETARJETADEBALT(?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);


									sentenciaStore.setInt("Par_LoteDebitoID",Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Par_TipoTarjetaDebID",Utileria.convierteEntero(tarjetaDebitoBean.getTipoTarjetaDebID()));
									sentenciaStore.setString("Par_FechaRegistro",tarjetaDebitoBean.getFechaRegistro());
									sentenciaStore.setString("Par_SucursalSolicita",tarjetaDebitoBean.getSucursalSolicita());
									sentenciaStore.setInt("Par_UsuarioID",parametrosAuditoriaBean.getUsuario());

									sentenciaStore.setInt("Par_NumTarjetas",Utileria.convierteEntero(tarjetaDebitoBean.getNumTarjetas()));
									sentenciaStore.setInt("Par_Estatus",Utileria.convierteEntero(tarjetaDebitoBean.getEstatus()));
									sentenciaStore.setString("Par_EsAdicional",tarjetaDebitoBean.getEsAdicional());
									sentenciaStore.setString("Par_NomArchiGen",tarjetaDebitoBean.getNomArchiGen());
									sentenciaStore.setInt("Par_FolioInicial",Utileria.convierteEntero(tarjetaDebitoBean.getFolioInicial()));

									sentenciaStore.setInt("Par_FolioFinal",Utileria.convierteEntero(tarjetaDebitoBean.getFolioFinal()));
									sentenciaStore.setInt("Par_BitCargaID",Utileria.convierteEntero(tarjetaDebitoBean.getLoteDebitoID()));
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","TarjetaDebitoDAO");

									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;


								} //public sql exception
							} // new CallableStatementCreator
							,new CallableStatementCallback() {
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
								}// public
							}// CallableStatementCallback
							);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de lote de tarjetas de debito", e);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}//catch
				return mensajeBean;
			} //public Object doInTransaction
		}); //men
		return mensaje;
	}

	public MensajeTransaccionBean insertaLoteTarjetaSAFI(int tipoTransaccion,final TarjetaDebitoBean tarjetaDebitoBean) {
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
									String query = "call LOTETARJETADEBSAFIALT(?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?, ?,?,?, ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_LoteDebitoSAFIID",Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Par_TipoTarjetaDebID",Utileria.convierteEntero(tarjetaDebitoBean.getTipoTarjetaDebID()));
									sentenciaStore.setString("Par_FechaRegistro",tarjetaDebitoBean.getFechaRegistro());
									sentenciaStore.setString("Par_SucursalSolicita",tarjetaDebitoBean.getSucursalSolicita());
									sentenciaStore.setInt("Par_UsuarioID",parametrosAuditoriaBean.getUsuario());

									sentenciaStore.setInt("Par_NumTarjetas",Utileria.convierteEntero(tarjetaDebitoBean.getNumTarjetas()));
									sentenciaStore.setInt("Par_Estatus",Utileria.convierteEntero(tarjetaDebitoBean.getEstatus()));
									sentenciaStore.setString("Par_EsAdicional",tarjetaDebitoBean.getEsAdicional());
									sentenciaStore.setString("Par_NomArchiGen",tarjetaDebitoBean.getNomArchiGen());
									sentenciaStore.setInt("Par_FolioInicial",Utileria.convierteEntero(tarjetaDebitoBean.getFolioInicial()));

									sentenciaStore.setInt("Par_FolioFinal",Utileria.convierteEntero(tarjetaDebitoBean.getFolioFinal()));
									sentenciaStore.setInt("Par_BitCargaID",Utileria.convierteEntero(tarjetaDebitoBean.getLoteDebitoID()));
									sentenciaStore.setString("Par_ServiceCode", tarjetaDebitoBean.getNumeroServicio());
									sentenciaStore.setString("Par_EsPersonaliz", Constantes.STRING_NO);
									sentenciaStore.setString("Par_EsVirtual", tarjetaDebitoBean.getEsVirtual());

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","TarjetaDebitoDAO");

									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;


								} //public sql exception
							} // new CallableStatementCreator
							,new CallableStatementCallback() {
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
								}// public
							}// CallableStatementCallback
							);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de lote de tarjetas de debito", e);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}//catch
				return mensajeBean;
			} //public Object doInTransaction
		}); //men
		return mensaje;
	}

	public MensajeTransaccionBean validaLoteTarjeta(int tipoTransaccion,final TarjetaDebitoBean tarjetaDebitoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						// Query con el Store Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
										new CallableStatementCreator() {
											public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
												String query =  "call LOTETARJETAVAL(?,?,?,?,?,  ?,?,?,?,?, ?,?,?);";
												CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_LoteDebitoID",Utileria.convierteEntero(tarjetaDebitoBean.getLoteDebitoID()));
									sentenciaStore.setInt("Par_Estatus",Utileria.convierteEntero(tarjetaDebitoBean.getEstatus()));
									sentenciaStore.setString("Par_NomArchiGen",tarjetaDebitoBean.getNomArchiGen());

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","TarjetaDebitoDAO");

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
					e.printStackTrace();
				if (mensajeBean.getNumero() == 0) {
				mensajeBean.setNumero(999);
				}
					mensajeBean.setDescripcion(e.getMessage());
					}
				return mensajeBean;
					}
					});
				return mensaje;
				}

	public MensajeTransaccionBean validaLoteTarjetaSAFI(int tipoTransaccion,final TarjetaDebitoBean tarjetaDebitoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						// Query con el Store Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
										new CallableStatementCreator() {
											public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
												String query =  "call LOTETARJETASAFIVAL(?,?,?,?,?,  ?,?,?,?,?, ?,?,?);";
												CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_LoteDebitoSAFIID",Utileria.convierteEntero(tarjetaDebitoBean.getLoteDebitoSAFIID()));
									sentenciaStore.setInt("Par_Estatus",Utileria.convierteEntero(tarjetaDebitoBean.getEstatus()));
									sentenciaStore.setString("Par_NomArchiGen",tarjetaDebitoBean.getNomArchiGen());

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","TarjetaDebitoDAO");

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
					e.printStackTrace();
				if (mensajeBean.getNumero() == 0) {
				mensajeBean.setNumero(999);
				}
					mensajeBean.setDescripcion(e.getMessage());
					}
				return mensajeBean;
					}
					});
			return mensaje;
	}

	public TarjetaDebitoBean consulta(final int tipoConsulta, TarjetaDebitoBean tarjetaDebitoBean){
		String query = "call TARJETADEBITOCON(?,?,?,?,?, ?,?,    ?,?,?,?, ?,?,?);";

		Object[] parametros = {
				tarjetaDebitoBean.getTarjetaDebID(),
				Utileria.convierteEntero(tarjetaDebitoBean.getLoteDebitoID()),
				Utileria.convierteLong(tarjetaDebitoBean.getCuentaAhoID()),
				Utileria.convierteEntero(tarjetaDebitoBean.getTipoTarjetaDebID()),
				Utileria.convierteEntero(tarjetaDebitoBean.getClienteID()),
				Constantes.STRING_VACIO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TarjetaDebitoDAO.consulta",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO

				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETADEBITOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TarjetaDebitoBean tarjetaDebitoBean = new TarjetaDebitoBean();
				tarjetaDebitoBean.setTarjetaDebID(resultSet.getString("TarjetaDebID"));
				tarjetaDebitoBean.setClienteID(resultSet.getString("ClienteID"));
				tarjetaDebitoBean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
				tarjetaDebitoBean.setNombreTarjeta(resultSet.getString("NombreTarjeta"));
				tarjetaDebitoBean.setRelacion(resultSet.getString("Relacion"));
				tarjetaDebitoBean.setTipoTarjetaDebID(resultSet.getString("TipoTarjetaDebID"));
				tarjetaDebitoBean.setEstatus(resultSet.getString("Estatus"));
				return tarjetaDebitoBean;
			}
		});
		return matches.size() > 0 ? (TarjetaDebitoBean) matches.get(0) : null;
	}
	public TarjetaDebitoBean consultaTar(final int tipoConsulta, TarjetaDebitoBean tarjetaDebitoBean){
		String query = "call TARJETADEBITOCON(?,?,?,?,?,?, ?,    ?,?,?,?, ?,?,?);";

		Object[] parametros = {
				tarjetaDebitoBean.getTarjetaDebID(),
				Utileria.convierteEntero(tarjetaDebitoBean.getLoteDebitoID()),
				Utileria.convierteLong(tarjetaDebitoBean.getCuentaAhoID()),
				Utileria.convierteEntero(tarjetaDebitoBean.getTipoTarjetaDebID()),
				Utileria.convierteEntero(tarjetaDebitoBean.getClienteID()),
				Constantes.STRING_VACIO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TarjetaDebitoDAO.consulta",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO

				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETADEBITOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TarjetaDebitoBean tarjetaDebitoBean = new TarjetaDebitoBean();
				tarjetaDebitoBean.setTarjetaDebID(resultSet.getString("TarjetaDebID"));
				tarjetaDebitoBean.setTipo(resultSet.getString("Descripcion"));
				tarjetaDebitoBean.setClienteID(resultSet.getString("ClienteID"));
				tarjetaDebitoBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				tarjetaDebitoBean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
				tarjetaDebitoBean.setEtiqueta(resultSet.getString("Etiqueta"));
				tarjetaDebitoBean.setClasificacion(resultSet.getString("Clasificacion"));
				tarjetaDebitoBean.setRelacion(resultSet.getString("CorpRelacionado"));
				tarjetaDebitoBean.setClienteCorporativo(resultSet.getString("ClienteCorporativo"));
				tarjetaDebitoBean.setRazonSocial(resultSet.getString("RazonSocial"));
				tarjetaDebitoBean.setTipoTarjetaDebID(resultSet.getString("TipoTarjetaDebID"));
				tarjetaDebitoBean.setIdentificacionSocio(resultSet.getString("IdentificacionSocio"));
				return tarjetaDebitoBean;
			}
		});
		return matches.size() > 0 ? (TarjetaDebitoBean) matches.get(0) : null;
	}


	public TarjetaDebitoBean consultaAsocia(final int tipoConsulta, TarjetaDebitoBean tarjetaDebitoBean){
		String query = "call TARJETADEBITOCON(?,?,?,?,?,?, ?,    ?,?,?,?, ?,?,?);";

		Object[] parametros = {
				tarjetaDebitoBean.getTarjetaDebID(),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TarjetaDebitoDAO.consulta",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO

				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETADEBITOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TarjetaDebitoBean tarjetaDebitoBean = new TarjetaDebitoBean();
				tarjetaDebitoBean.setTarjetaDebID(resultSet.getString("TarjetaDebID"));
				tarjetaDebitoBean.setDescripcion(resultSet.getString("Descripcion"));
				tarjetaDebitoBean.setClienteID(resultSet.getString("ClienteID"));
				tarjetaDebitoBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				tarjetaDebitoBean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
				tarjetaDebitoBean.setEtiqueta(resultSet.getString("Etiqueta"));
				tarjetaDebitoBean.setClasificacion(resultSet.getString("Clasificacion"));
				tarjetaDebitoBean.setCorpRelacionado(resultSet.getString("CorpRelacionado"));
				tarjetaDebitoBean.setClienteCorporativo(resultSet.getString("ClienteCorporativo"));
				tarjetaDebitoBean.setRazonSocial(resultSet.getString("RazonSocial"));
				tarjetaDebitoBean.setTipoTarjetaDebID(resultSet.getString("TipoTarjetaDebID"));
				tarjetaDebitoBean.setEstatus(resultSet.getString("Estatus"));
				tarjetaDebitoBean.setNombreTarjeta(resultSet.getString("NombreTarjeta"));
				return tarjetaDebitoBean;
			}
		});
		return matches.size() > 0 ? (TarjetaDebitoBean) matches.get(0) : null;
	}


	//------------- actualizacion  para Asociar una tarjeta de Crédito a una cuentaCliente----------------------
	public MensajeTransaccionBean actualiza(final int tipoActualizacion,final TarjetaDebitoBean tarjetaDebitoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean= actualizaTD(tipoActualizacion, tarjetaDebitoBean);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				ParamGeneralesBean paramGeneralBean = paramGeneralesServicio.consulta(tipoConsultaTD, new ParamGeneralesBean());
					if(paramGeneralBean == null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado - Tipo Conexion TD");
					}

				if(tarjetaDebitoBean.getIdentificacionSocio().equalsIgnoreCase("N") & paramGeneralBean.getValorParametro().equalsIgnoreCase(conexionEntura)){
					try {

						String endPointAsocTarjEntura   = PropiedadesSAFIBean.propiedadesSAFI.getProperty("endPointAsocTarjEntura");
						String endPointAsocTarjEnturaIP = PropiedadesSAFIBean.propiedadesSAFI.getProperty("endPointAsocTarjEnturaIP");
						String relacionTarjeta="";
						WsRelacionClienteTarjetaProxy relTarjetaCta = new WsRelacionClienteTarjetaProxy(endPointAsocTarjEntura);
						if(tarjetaDebitoBean.getRelacion().equals("T")){
							relacionTarjeta="1";
						}
						if(tarjetaDebitoBean.getRelacion().equals("A")){
							relacionTarjeta="2";
						}
						ClienteBean clienteBean = null;
						clienteBean = clienteServicio.consulta(22, tarjetaDebitoBean.getClienteID(),"");
						String resultado=	relTarjetaCta.relacionClienteTarjeta(clienteBean.getCodCooperativa(), clienteBean.getCodUsuario(),
								endPointAsocTarjEnturaIP,
								clienteBean.getCURP(), Integer.parseInt(clienteBean.getTipoDocumento()), clienteBean.getPrimerNombre(),
								clienteBean.getApellidoPaterno(),tarjetaDebitoBean.getCuentaAhoID(), clienteBean.getTipoCuenta(),clienteBean.getCodMoneda(),
								clienteBean.getDireccion(),clienteBean.getTipoDireccion(),clienteBean.getCorreo(), clienteBean.getTelefonoCasa(),
								clienteBean.getTipoTelefono(),tarjetaDebitoBean.getTarjetaDebID(),clienteBean.getEstadoCivil(),
								clienteBean.getSexo(), clienteBean.getFechaNacimiento(), relacionTarjeta);

						if(resultado.startsWith("000")){

						}
						else{
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							mensajeBean.setDescripcion(resultado);
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (RemoteException e) {
						e.printStackTrace();
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("Error al Conectar con WS Entura.");
						throw new Exception(mensajeBean.getDescripcion());
					}
				}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualiza tarjeta ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}



	//------------- actualizacion  para Asociar una tarjeta de Crédito a una cuentaCliente----------------------
	public MensajeTransaccionBean actualizaTD(final int tipoActualizacion,final TarjetaDebitoBean tarjetaDebitoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call TARJETADEBITOACT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,? );";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_TarjetaDebID",tarjetaDebitoBean.getTarjetaDebID());
								sentenciaStore.setString("Par_FechaActivacion",Utileria.convierteFecha(tarjetaDebitoBean.getFechaActivacion()));
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(tarjetaDebitoBean.getClienteID()));
								sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(tarjetaDebitoBean.getCuentaAhoID()));
								sentenciaStore.setString("Par_NombreTarjeta",tarjetaDebitoBean.getNombreTarjeta());
								sentenciaStore.setString("Par_Relacion",tarjetaDebitoBean.getRelacion());
								sentenciaStore.setInt("Par_TipoTarjetaDebID",Utileria.convierteEntero(tarjetaDebitoBean.getTipoTarjetaDebID()));
								sentenciaStore.setInt("Par_TipoCuentaID",Utileria.convierteEntero(tarjetaDebitoBean.getTipoCuentaID()));
								sentenciaStore.setString("Par_TipoCobro",tarjetaDebitoBean.getTipoCobro());
								sentenciaStore.setInt("Par_NumAct",tipoActualizacion);

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
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualiza tarjeta ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Lista tipo de tarjetas de Debito */
	public List listaTarjetas(TarjetaDebitoBean tarjetaDebitoBean, int tipoLista) {
		List listaTarjetas=null;
		try{
		String query = "call TARJETADEBITOLIS(?,?,?,?, ?,?,?, ?,?,?,?);";
		Object[] parametros = {
								tarjetaDebitoBean.getTarjetaDebID(),
								tarjetaDebitoBean.getTipoTarjetaDebID(),
								tarjetaDebitoBean.getCuentaAhoID(),
								tipoLista,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TipoTarjetaDebDAO.listaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETADEBITOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				TarjetaDebitoBean TarjetaDebito = new TarjetaDebitoBean();
				TarjetaDebito.setTarjetaDebID(resultSet.getString("TarjetaDebID"));

				return TarjetaDebito;
			}
		});

		listaTarjetas= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de tarjetas de debito", e);
		}
		return listaTarjetas;
	}

	public List listTarEstatus(TarjetaDebitoBean tarjetaDebitoBean, int tipoLista) {
		List listaTarjetas=null;
		try{
		String query = "call TARJETADEBITOLIS(?,?,?, ?,?,?, ?,?,?,?,?);";
		Object[] parametros = {
								tarjetaDebitoBean.getTarjetaDebID(),
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,

								tipoLista,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TipoTarjetaDebDAO.listaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETADEBITOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				TarjetaDebitoBean tarjetaDebito = new TarjetaDebitoBean();
				tarjetaDebito.setTarjetaDebID(resultSet.getString("TarjetaDebID"));
				tarjetaDebito.setNombreComp(resultSet.getString("NombreCompleto"));
				return tarjetaDebito;
			}
		});

		listaTarjetas= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de tarjetas de debito", e);
		}
		return listaTarjetas;
	}


	/* Lista tarjetas de Debito con el nombre del cliente */
	public List listaTarjetasDeb(TarjetaDebitoBean tarjetaDebitoBean, int tipoLista) {
		List listaTarjetasDeb=null;
		try{
		String query = "call TARJETADEBITOLIS(?,?,?, ?,?,?, ?,?,?,?,?);";
		Object[] parametros = {
								tarjetaDebitoBean.getTarjetaDebID(),
								tarjetaDebitoBean.getTipoTarjetaDebID(),
								tarjetaDebitoBean.getCuentaAhoID(),
								tipoLista,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"listaTarjetasDeb",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETADEBITOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				TarjetaDebitoBean tarjetaDebito = new TarjetaDebitoBean();
				tarjetaDebito.setTarjetaDebID(resultSet.getString("TarjetaDebID"));
				tarjetaDebito.setNombre(resultSet.getString("NombreCompleto"));

				return tarjetaDebito;
			}
		});

		listaTarjetasDeb= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de tarjetas de debito", e);
		}
		return listaTarjetasDeb;
	}

	// Activacion de Tarjetas
	public MensajeTransaccionBean activa(int tipoTransaccion,final TarjetaDebitoBean tarjetaDebitoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL TARDEBACTIVARALT(?,?,?, ?,?,?, ?,?,? ,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_TarjetaDebID", tarjetaDebitoBean.getTarjetaDebID());

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","TarjetaDebitoDAO");
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;


								} //public sql exception
							} // new CallableStatementCreator
							,new CallableStatementCallback() {
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
								}// public
							}// CallableStatementCallback
							);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Activacion de tarjeta de debito", e);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}//catch
				return mensajeBean;
			} //public Object doInTransaction
		}); //men
		return mensaje;
	}


	//Consulta datos de la tarjeta de debito consulta#9
	public TarjetaDebitoBean consultaTarDebAsigna(final int tipoConsulta, TarjetaDebitoBean tarjetaDebitoBean){
		String query = "call TARJETADEBITOCON(?,?,?,?,?,?, ?,    ?,?,?,?, ?,?,?);";

		Object[] parametros = {
				tarjetaDebitoBean.getTarjetaDebID(),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TarjetaDebitoDAO.consulta",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO

				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETADEBITOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TarjetaDebitoBean tarjetaDebitoBean = new TarjetaDebitoBean();
				tarjetaDebitoBean.setTarjetaDebID(resultSet.getString("TarjetaDebID"));
				tarjetaDebitoBean.setCorpRelacionado(resultSet.getString("CorpRelacionado"));
				tarjetaDebitoBean.setClienteID(resultSet.getString("ClienteCorporativo"));
				tarjetaDebitoBean.setEstatus(resultSet.getString("Estatus"));

				return tarjetaDebitoBean;
			}
		});
		return matches.size() > 0 ? (TarjetaDebitoBean) matches.get(0) : null;
	}


	public List TarjetaDeb(int tipoLista,TarjetaDebitoBean tarjetaDebitoBean ) {


		String query = "call TARJETADEBITOLIS(?,?,?,?,    ?    ,?,?, ?,?,?,?);";
		Object[] parametros = {
				tarjetaDebitoBean.getTarjetaDebID(),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"TARDEBDESQMANTARLIS.listaPrincipal",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETADEBITOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {

				TarjetaDebitoBean tarjetaDebitoBean= new TarjetaDebitoBean();
				tarjetaDebitoBean.setTarjetaDebID(resultSet.getString(1));
				tarjetaDebitoBean.setNombreComp(resultSet.getString(2));


				return tarjetaDebitoBean;

			}
		});
		return matches;
	}

	public List TarDebListaCtaUnica(int tipoLista,TarjetaDebitoBean tarjetaDebitoBean ) {


		String query = "call TARJETADEBITOLIS(?,?,?,?,    ?    ,?,?, ?,?,?,?);";
		Object[] parametros = {
				tarjetaDebitoBean.getTarjetaDebID(),
				Constantes.ENTERO_CERO,
				tarjetaDebitoBean.getCuentaAhoID(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"TARDEBDESQMANTARLIS.listaPorCuentaTar",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETADEBITOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {

				TarjetaDebitoBean tarjetaDebitoBean= new TarjetaDebitoBean();
				tarjetaDebitoBean.setTarjetaDebID(resultSet.getString(1));
				tarjetaDebitoBean.setNombreComp(resultSet.getString(2));


				return tarjetaDebitoBean;

			}
		});
		return matches;
	}

	/* Lista de Tarjetas Existentes */
	public List listTarExistente(int tipoLista,TarjetaDebitoBean tarjetaDebitoBean ) {
		String query = "call TARJETADEBITOLIS(?,?,?,?,    ?,?,?, ?,?,?,?);";
		Object[] parametros = {
				tarjetaDebitoBean.getTarjetaDebID(),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"TarjetaDebitoDAO.listTarExistente",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETADEBITOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				TarjetaDebitoBean tarjetaDebitoBean = new TarjetaDebitoBean();
				tarjetaDebitoBean.setTarjetaDebID(resultSet.getString("TarjetaDebID"));
				tarjetaDebitoBean.setNombreComp(resultSet.getString("NombreCompleto"));
				return tarjetaDebitoBean;
			}
		});
		return matches;
	}
	public TarjetaDebitoBean consultaTarjetaDeb(int tipoConsulta,TarjetaDebitoBean tarjetaDebitoBean){
		String query = "call TARJETADEBITOCON(?,?,?,?,?,?, ?,    ?,?,?,?,?,?,?);";

		Object[] parametros = {
				tarjetaDebitoBean.getTarjetaDebID(),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,

				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TARJETADEBITOBCON.consultaForanea",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETADEBITOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				TarjetaDebitoBean bloqueoTarDeb = new TarjetaDebitoBean();
				bloqueoTarDeb.setTarjetaDebID(resultSet.getString(1));
				bloqueoTarDeb.setEstatus(resultSet.getString(2));
				bloqueoTarDeb.setTarjetaHabiente(resultSet.getString(3));
				bloqueoTarDeb.setNombreComp(resultSet.getString(4));
				bloqueoTarDeb.setCoorporativo(resultSet.getString(5));
				bloqueoTarDeb.setEstatusId(resultSet.getString(6));
					return bloqueoTarDeb;
			}
		});

		return matches.size() > 0 ? (TarjetaDebitoBean) matches.get(0) : null;
	}


	//------------------------------alta de tarjeta debito bloqueo --------------
	public MensajeTransaccionBean bloqueoTarjeta(final int tipoTransaccion, final TarjetaDebitoBean tarjetaDebitoBean) {
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
								String query = "call TARDEBBLOQMANALT(?,?,?,?,?,       ?,?,?,?,    ?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_NumTarjeta",tarjetaDebitoBean.getTarjetaDebID());
								sentenciaStore.setInt("Par_TarjetaHabiente",Utileria.convierteEntero(tarjetaDebitoBean.getTarjetaHabiente()));
								sentenciaStore.setInt("Par_CorporativoID",Utileria.convierteEntero(tarjetaDebitoBean.getCoorporativo()));
								sentenciaStore.setInt("Par_MotivoBloqID",Utileria.convierteEntero(tarjetaDebitoBean.getMotivoBloqID()));
								sentenciaStore.setString("Par_DescAdicional",tarjetaDebitoBean.getDescripcion());

								sentenciaStore.setInt("Par_TipoTran",tipoTransaccion);
								sentenciaStore.setString("Par_Salida",	Constantes.salidaSI);
								// Parametros de OutPut
								sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);


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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de cuentas de personal", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	///-------------------alta de tarjeta debito desbloqueo----------------
	public MensajeTransaccionBean desbloqueoTarjeta(final int tipoTransaccion, final TarjetaDebitoBean tarjetaDebitoBean) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure


			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call TARDEBDESBLOQMANALT(?,?,?,?,?,       ?,?,?,?,    ?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_NumTarjeta",tarjetaDebitoBean.getTarjetaDebID());
								sentenciaStore.setInt("Par_TarjetaHabiente",Utileria.convierteEntero(tarjetaDebitoBean.getTarjetaHabiente()));
								sentenciaStore.setInt("Par_CorporativoID",Utileria.convierteEntero(tarjetaDebitoBean.getCoorporativo()));
								sentenciaStore.setInt("Par_MotivoBloqID",Utileria.convierteEntero(tarjetaDebitoBean.getMotivoBloqID()));
								sentenciaStore.setString("Par_DescAdicional",tarjetaDebitoBean.getDescripcion());

								sentenciaStore.setInt("Par_TipoTran",tipoTransaccion);
								sentenciaStore.setString("Par_Salida",	Constantes.salidaSI);
								// Parametros de OutPut
								sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);


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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de cuentas de personal", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	//--------------------------------------------cancelacion--------------------------
	public MensajeTransaccionBean cancelacionTarjetaDebito(final int tipoTransaccion, final TarjetaDebitoBean tarjetaDebitoBean) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure


			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call TARDEBCANCELALT(?,?,?,?,?,       ?,?,?,?,    ?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_NumTarjeta",tarjetaDebitoBean.getTarjetaDebID());
								sentenciaStore.setInt("Par_TarjetaHabiente",Utileria.convierteEntero(tarjetaDebitoBean.getTarjetaHabiente()));
								sentenciaStore.setInt("Par_CorporativoID",Utileria.convierteEntero(tarjetaDebitoBean.getCoorporativo()));
								sentenciaStore.setInt("Par_MotivoBloqID",Utileria.convierteEntero(tarjetaDebitoBean.getMotivoBloqID()));
								sentenciaStore.setString("Par_DescAdicional",tarjetaDebitoBean.getDescripcion());

								sentenciaStore.setInt("Par_TipoTran",tipoTransaccion);
								sentenciaStore.setString("Par_Salida",	Constantes.salidaSI);
								// Parametros de OutPut
								sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);


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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de cuentas de personal", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	//---------------------------------conuslta de bitacora de tarjetas debitos Bloqueo------------------------------------
	public TarjetaDebitoBean consultaBitacoTarjetaDebBloq(int tipoConsulta,TarjetaDebitoBean tarjetaDebitoBean){

		String query = "call BITACOTARDEBCON(?,?,   ?,?,?,?,?,?,?);";

		Object[] parametros = {
				tarjetaDebitoBean.getTarjetaDebID(),

				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TARJETADEBITOBCON.consultaBitacoTarjetaDeb",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BITACOTARDEBCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				TarjetaDebitoBean bloqueoTarDeb = new TarjetaDebitoBean();
				bloqueoTarDeb.setTarjetaDebID(resultSet.getString(1));
				bloqueoTarDeb.setEstatus(resultSet.getString(2));
				bloqueoTarDeb.setTarjetaHabiente(resultSet.getString(3));
				bloqueoTarDeb.setNombreComp(resultSet.getString(4));
				bloqueoTarDeb.setCoorporativo(resultSet.getString(5));
				bloqueoTarDeb.setMotivoBloqueo(resultSet.getString(6));
				bloqueoTarDeb.setFechaBloqueo(resultSet.getString(7));
				bloqueoTarDeb.setDescriBloqueo(resultSet.getString(8));

					return bloqueoTarDeb;
			}
		});

		return matches.size() > 0 ? (TarjetaDebitoBean) matches.get(0) : null;


	}

	//------------------------------------consulta de bitacora de tarjeta debito  cancel-----------------------
	public TarjetaDebitoBean consultaBitacoTarjetaDebDesbloq(int tipoConsulta,TarjetaDebitoBean tarjetaDebitoBean){

		String query = "call BITACOTARDEBCON(?,?,   ?,?,?,?,?,?,?);";

		Object[] parametros = {
				tarjetaDebitoBean.getTarjetaDebID(),

				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TARJETADEBITOBCON.consultaBitacoTarjetaDeb",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BITACOTARDEBCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				TarjetaDebitoBean bloqueoTarDeb = new TarjetaDebitoBean();
				bloqueoTarDeb.setTarjetaDebID(resultSet.getString(1));
				bloqueoTarDeb.setEstatus(resultSet.getString(2));
				bloqueoTarDeb.setTarjetaHabiente(resultSet.getString(3));
				bloqueoTarDeb.setNombreComp(resultSet.getString(4));
				bloqueoTarDeb.setCoorporativo(resultSet.getString(5));
				bloqueoTarDeb.setMotivoBloqueo(resultSet.getString(6));
				bloqueoTarDeb.setFechaBloqueo(resultSet.getString(7));
				bloqueoTarDeb.setDescriBloqueo(resultSet.getString(8));
				bloqueoTarDeb.setEstatusId(resultSet.getString(9));


					return bloqueoTarDeb;
			}
		});

		return matches.size() > 0 ? (TarjetaDebitoBean) matches.get(0) : null;
	}


	public TarjetaDebitoBean consultaTarjetaCancel(int tipoConsulta,TarjetaDebitoBean tarjetaDebitoBean){
		String query = "call TARJETADEBITOCON(?,?,?,?,?,?, ?,    ?,?,?,?,?,?,?);";

		Object[] parametros = {
				tarjetaDebitoBean.getTarjetaDebID(),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,

				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TARJETADEBITOBCON.consultaForanea",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETADEBITOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				TarjetaDebitoBean bloqueoTarDeb = new TarjetaDebitoBean();
				bloqueoTarDeb.setTarjetaDebID(resultSet.getString(1));

				bloqueoTarDeb.setTarjetaHabiente(resultSet.getString(2));
				bloqueoTarDeb.setNombreComp(resultSet.getString(3));
				bloqueoTarDeb.setEstatus(resultSet.getString(4));
				bloqueoTarDeb.setCoorporativo(resultSet.getString(5));
				bloqueoTarDeb.setEstatusId(resultSet.getString(6));

					return bloqueoTarDeb;
			}
		});

		return matches.size() > 0 ? (TarjetaDebitoBean) matches.get(0) : null;
	}


	public TarjetaDebitoBean principal(final int tipoConsulta, TarjetaDebitoBean tarjetaDebitoBean){
		String query = "call TARJETADEBITOCON(?,?,?,?,?,?,?,   ?,?,?,?, ?,?,?);";

		Object[] parametros = {
				tarjetaDebitoBean.getTarjetaDebID(),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TarjetaDebitoDAO.consulta",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO

				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETADEBITOCON(" + Arrays.toString(parametros) +")");
		@SuppressWarnings("unchecked")
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TarjetaDebitoBean tarjetaDebitoBean = new TarjetaDebitoBean();
				tarjetaDebitoBean.setTarjetaDebID(resultSet.getString("TarjetaDebID"));
				tarjetaDebitoBean.setLoteDebitoID(resultSet.getString("LoteDebitoID"));
				tarjetaDebitoBean.setFechaRegistro(resultSet.getString("FechaRegistro"));
				tarjetaDebitoBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
				tarjetaDebitoBean.setFechaActivacion(resultSet.getString("FechaActivacion"));
				tarjetaDebitoBean.setEstatus(resultSet.getString("Estatus"));
				tarjetaDebitoBean.setClienteID(resultSet.getString("ClienteID"));

				tarjetaDebitoBean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
				tarjetaDebitoBean.setFechaBloqueo(resultSet.getString("FechaBloqueo"));
				tarjetaDebitoBean.setMotivoBloqueo(resultSet.getString("MotivoBloqueo"));
				tarjetaDebitoBean.setFechaCancelacion(resultSet.getString("FechaCancelacion"));
				tarjetaDebitoBean.setMotivoCancelacion(resultSet.getString("MotivoCancelacion"));
				tarjetaDebitoBean.setFechaDesbloqueo(resultSet.getString("FechaDesbloqueo"));

				tarjetaDebitoBean.setMotivoDesbloqueo(resultSet.getString("MotivoDesbloqueo"));
				tarjetaDebitoBean.setnIP(resultSet.getString("NIP"));
				tarjetaDebitoBean.setNombreTarjeta(resultSet.getString("NombreTarjeta"));
				tarjetaDebitoBean.setRelacion(resultSet.getString("Relacion"));
				tarjetaDebitoBean.setSucursalID(resultSet.getString("SucursalID"));
				tarjetaDebitoBean.setTipoTarjetaDebID(resultSet.getString("TipoTarjetaDebID"));

				return tarjetaDebitoBean;
			}
		});
		return matches.size() > 0 ? (TarjetaDebitoBean) matches.get(0) : null;
	}
	//Consulta lote de tarjetas
	public TarjetaDebitoBean loteTarjetaCon(final int tipoConsulta, TarjetaDebitoBean tarjetaDebitoBean){
		String query = "call LOTETARJETACON(?,?,   ?,?,?,?,?,?,?);";
		Object[] parametros = {

				Constantes.ENTERO_CERO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TarjetaDebitoDAO.consulta",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO

				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call LOTETARJETACON(" + Arrays.toString(parametros) +")");
		@SuppressWarnings("unchecked")
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TarjetaDebitoBean tarjetaDebitoBean = new TarjetaDebitoBean();
				tarjetaDebitoBean.setLoteDebitoID(resultSet.getString("LoteDebitoID"));
				tarjetaDebitoBean.setTipoTarjetaDebID(resultSet.getString("TipoTarjetaDebID"));
				tarjetaDebitoBean.setFechaRegistro(resultSet.getString("FechaRegistro"));
				tarjetaDebitoBean.setSucursalSolicita(resultSet.getString("SucursalSolicita"));
				tarjetaDebitoBean.setEstatus(resultSet.getString("Estatus"));
				tarjetaDebitoBean.setEsAdicional(resultSet.getString("EsAdicional"));
				tarjetaDebitoBean.setFolioFinal(resultSet.getString("FolioFinal"));

				return tarjetaDebitoBean;
			}
		});
		return matches.size() > 0 ? (TarjetaDebitoBean) matches.get(0) : null;
	}

	/*Consulta para la pantalla de Solicitud de Tarjeta Nominativa  */
	public TarjetaDebitoBean consultaComisionSol(final int tipoConsulta, TarjetaDebitoBean tarjetaDebitoBean){
		String query = "call TARJETADEBITOCON(?,?,?,?,?,?,?,   ?,?,?,?, ?,?,?);";

		Object[] parametros = {
				tarjetaDebitoBean.getTarjetaDebID(),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TarjetaDebitoDAO.consultaComisionSol",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO

				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETADEBITOCON(" + Arrays.toString(parametros) +")");
		@SuppressWarnings("unchecked")
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TarjetaDebitoBean tarjetaDebitoBean = new TarjetaDebitoBean();
				tarjetaDebitoBean.setClienteID(resultSet.getString("ClienteID"));
				tarjetaDebitoBean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
				tarjetaDebitoBean.setMontoComision(resultSet.getString("MontoComision"));
				return tarjetaDebitoBean;
			}
		});
		return matches.size() > 0 ? (TarjetaDebitoBean) matches.get(0) : null;
	}


	/* ======= EJECUTA EL PROCESO DE PAGO DE COMISION ANUAL A TARJETAS DE DEBITO =========== */
	public MensajeTransaccionBean pagoComisionAnual(int tipoActualizacion,final TarjetaDebitoBean tarjetaDebitoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call TARDEBPAGOCOMPRO(?,?,  ?,?,?,?,?,  ?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_TipoTarjetaDebID", Utileria.convierteEntero( tarjetaDebitoBean.getTipoTarjetaDebID()));
									sentenciaStore.setInt("Par_UsuarioID", Utileria.convierteEntero( tarjetaDebitoBean.getNombreUsuario()));

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


								} //public sql exception
							} // new CallableStatementCreator
							,new CallableStatementCallback() {
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
								}// public
							}// CallableStatementCallback
							);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Pago Comisión Anual de tarjeta de débito", e);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}//catch
				return mensajeBean;
			} //public Object doInTransaction
		}); //men
		return mensaje;
	}


	/*Consulta para la pantalla de Consulta de Movimientos por Tarjeta  */
	public TarjetaDebitoBean consultaMovTarjetas(final int tipoConsulta, TarjetaDebitoBean tarjetaDebitoBean){
		String query = "call TARJETADEBITOCON(?,?,?,?,?,?,?,   ?,?,?,?, ?,?,?);";

		Object[] parametros = {
				tarjetaDebitoBean.getTarjetaDebID(),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TarjetaDebitoDAO.consultaMovTarjetas",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO

				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETADEBITOCON(" + Arrays.toString(parametros) +")");
		@SuppressWarnings("unchecked")
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TarjetaDebitoBean tarjetaDebitoBean = new TarjetaDebitoBean();
				tarjetaDebitoBean.setTarjetaDebID(resultSet.getString("TarjetaDebID"));
				tarjetaDebitoBean.setDescripcion(resultSet.getString("Descripcion"));
				tarjetaDebitoBean.setClienteID(
				 (resultSet.getString("ClienteID")!=null) ?
						   Utileria.completaCerosIzquierda(
								   Utileria.convierteEntero(resultSet.getString("ClienteID")
										   ),BitacoraEstatusTarDebBean.LONGITUD_ID) : Constantes.STRING_VACIO );
				tarjetaDebitoBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				tarjetaDebitoBean.setCoorporativo(resultSet.getString("CorpRelacionado"));
				tarjetaDebitoBean.setCuentaAhoID(
				 (resultSet.getString("CuentaAhoID")!=null) ?
						   Utileria.completaCerosIzquierda(
								   Utileria.convierteLong(resultSet.getString("CuentaAhoID")
										   ),BitacoraEstatusTarDebBean.LONGITUD_ID) : Constantes.STRING_VACIO);
				tarjetaDebitoBean.setTipoCuentaID(resultSet.getString("NombreCuenta"));
				tarjetaDebitoBean.setTipoTarjetaDebID(resultSet.getString("TipoTarjetaDebID"));
				tarjetaDebitoBean.setNombreTarjeta(resultSet.getString("NombreTarjeta"));
				tarjetaDebitoBean.setEstatusId(resultSet.getString("Estatus"));
				tarjetaDebitoBean.setIdentificacionSocio(resultSet.getString("IdentificacionSocio"));
				return tarjetaDebitoBean;
			}
		});
		return matches.size() > 0 ? (TarjetaDebitoBean) matches.get(0) : null;
	}


	/*Consulta los datos de una tarjeta de debito que tenga asociada una cuenta especificada  */
	public TarjetaDebitoBean consultaTarDebCuenta(final int tipoConsulta, TarjetaDebitoBean tarjetaDebitoBean){
		String query = "call TARJETADEBITOCON(?,?,?,?,?,?,?,   ?,?,?,?, ?,?,?);";

		Object[] parametros = {
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Utileria.convierteLong(tarjetaDebitoBean.getCuentaAhoID()),
				Utileria.convierteEntero(tarjetaDebitoBean.getTipoTarjetaDebID()),
				Constantes.ENTERO_CERO,
				tarjetaDebitoBean.getRelacion(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TarjetaDebitoDAO.consultaComisionSol",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO

				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETADEBITOCON(" + Arrays.toString(parametros) +")");
		@SuppressWarnings("unchecked")
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TarjetaDebitoBean tarjetaDebitoBean = new TarjetaDebitoBean();
				tarjetaDebitoBean.setTarjetaDebID(resultSet.getString("TarjetaDebID"));
				tarjetaDebitoBean.setEstatus(resultSet.getString("Estatus"));
				tarjetaDebitoBean.setTipoTarjetaDebID(resultSet.getString("TipoTarjetaDebID"));
				tarjetaDebitoBean.setRelacion(resultSet.getString("Relacion"));
				tarjetaDebitoBean.setTipoCobro(resultSet.getString("TipoCobro"));
				tarjetaDebitoBean.setNombreTarjeta(resultSet.getString("NombreTarjeta"));
				return tarjetaDebitoBean;
			}
		});
		return matches.size() > 0 ? (TarjetaDebitoBean) matches.get(0) : null;
	}


	/*Consulta de Tarjetas Existentes */
	public TarjetaDebitoBean consultaTarExistentes(final int tipoConsulta, TarjetaDebitoBean tarjetaDebitoBean){
		String query = "call TARJETADEBITOCON(?,?,?,?,?,?,?,   ?,?,?,?, ?,?,?);";

		Object[] parametros = {
				tarjetaDebitoBean.getTarjetaDebID(),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TarjetaDebitoDAO.consultaMovTarjetas",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO

				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETADEBITOCON(" + Arrays.toString(parametros) +")");
		@SuppressWarnings("unchecked")
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TarjetaDebitoBean tarjetaDebitoBean = new TarjetaDebitoBean();
				tarjetaDebitoBean.setTarjetaDebID(resultSet.getString("TarjetaDebID"));
				tarjetaDebitoBean.setDescripcion(resultSet.getString("Descripcion"));
				tarjetaDebitoBean.setClienteID(
				 (resultSet.getString("ClienteID")!=null) ?
						   Utileria.completaCerosIzquierda(
								   Utileria.convierteEntero(resultSet.getString("ClienteID")
										   ),BitacoraEstatusTarDebBean.LONGITUD_ID) : Constantes.STRING_VACIO );
				tarjetaDebitoBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				tarjetaDebitoBean.setCoorporativo(resultSet.getString("CorpRelacionado"));
				tarjetaDebitoBean.setCuentaAhoID(
				 (resultSet.getString("CuentaAhoID")!=null) ?
						   Utileria.completaCerosIzquierda(
								   Utileria.convierteLong(resultSet.getString("CuentaAhoID")
										   ),BitacoraEstatusTarDebBean.LONGITUD_ID) : Constantes.STRING_VACIO);
				tarjetaDebitoBean.setTipoCuentaID(resultSet.getString("NombreCuenta"));
				tarjetaDebitoBean.setTipoTarjetaDebID(resultSet.getString("TipoTarjetaDebID"));
				tarjetaDebitoBean.setNombreTarjeta(resultSet.getString("NombreTarjeta"));
				tarjetaDebitoBean.setEstatusId(resultSet.getString("Estatus"));
				return tarjetaDebitoBean;
			}
		});
		return matches.size() > 0 ? (TarjetaDebitoBean) matches.get(0) : null;
	}


	/*19 Consulta para pago anual de Tarjeta de Debito */
	public TarjetaDebitoBean consultaPagoAnual(final int tipoConsulta, TarjetaDebitoBean tarjetaDebitoBean){
		String query = "call TARJETADEBITOCON(?,?,?,?,?,?,?,   ?,?,?,?, ?,?,?);";

		Object[] parametros = {
				tarjetaDebitoBean.getTarjetaDebID(),
				Constantes.ENTERO_CERO,
				Utileria.convierteLong(tarjetaDebitoBean.getCuentaAhoID()),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TarjetaDebitoDAO.consultaPagoAnual",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO

				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETADEBITOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TarjetaDebitoBean tarjetaDebitoBean = new TarjetaDebitoBean();

				tarjetaDebitoBean.setTarjetaDebID(resultSet.getString("TarjetaDebID"));
				tarjetaDebitoBean.setEstatusId(resultSet.getString("Estatus"));
				tarjetaDebitoBean.setTipoTarjetaDebID(resultSet.getString("TipoTarjetaDebID"));
				tarjetaDebitoBean.setClienteID(resultSet.getString("ClienteID"));
				tarjetaDebitoBean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));

				tarjetaDebitoBean.setPagoComAnual(resultSet.getString("PagoComAnual"));
				tarjetaDebitoBean.setFPagoComAnual(resultSet.getString("FPagoComAnual"));
				tarjetaDebitoBean.setComisionAnual(resultSet.getString("ComisionAnual"));
				tarjetaDebitoBean.setFechaActivacion(resultSet.getString("FechaActivacion"));
				tarjetaDebitoBean.setFechaProximoPag(resultSet.getString("FechaProximoPag"));

				tarjetaDebitoBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				tarjetaDebitoBean.setCorpRelacionado(resultSet.getString("CorpRelacionado"));
				tarjetaDebitoBean.setTipoCuentaID(resultSet.getString("TipoCuentaID"));
				tarjetaDebitoBean.setDesTipoCta(resultSet.getString("DesTipoCta"));
				tarjetaDebitoBean.setDesTipoTarjeta(resultSet.getString("DesTipoTarjeta"));
				tarjetaDebitoBean.setEstatus(resultSet.getString("DesEstatus"));
				tarjetaDebitoBean.setIdentificacionSocio(resultSet.getString("IdentificacionSocio"));

				return tarjetaDebitoBean;




			}
		});
		return matches.size() > 0 ? (TarjetaDebitoBean) matches.get(0) : null;
	}

	/* 21 .- Consulta de Bitacora de Pago de Comision Anual */
	public TarjetaDebitoBean consultaBitacoraPago(final int tipoConsulta, TarjetaDebitoBean tarjetaDebitoBean){
		String query = "call BITACORAPAGOCOMCON(?,?,  ?,?,?,?, ?,?,?);";

		Object[] parametros = {
				tarjetaDebitoBean.getTipoTarjetaDebID(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TarjetaDebitoDAO.consultaBitacoraPago",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BITACORAPAGOCOM(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TarjetaDebitoBean tarjetaDebitoBean = new TarjetaDebitoBean();
				tarjetaDebitoBean.setTipoTarjetaDebID(resultSet.getString("TipoTarjetaDebID"));
				return tarjetaDebitoBean;
			}
		});
		return matches.size() > 0 ? (TarjetaDebitoBean) matches.get(0) : null;
	}

	/**
	 * PAGO DE ANUALIDAD DE TARJETA DE CREDITO EN VENTANILLA
	 * @param ingresosOperacionesBean
	 * @param tipoTransaccion
	 * @param origenVentanilla
	 * @return
	 */
	public MensajeTransaccionBean pagoAnuliadadTarjeta(final IngresosOperacionesBean ingresosOperacionesBean, long tipoTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		//transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PAGOANUALTARJETAPRO(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setString("Par_TarjetaDebID", ingresosOperacionesBean.getTarjetaDebID());
							sentenciaStore.setString("Par_SucursalID", ingresosOperacionesBean.getSucursalID());
							sentenciaStore.setInt("Par_CajaID", Utileria.convierteEntero(ingresosOperacionesBean.getCajaID()));
							sentenciaStore.setDouble("Par_MontoComision", Utileria.convierteDoble(ingresosOperacionesBean.getMonto()));
							sentenciaStore.setDouble("Par_MontoIVA", Utileria.convierteDoble(ingresosOperacionesBean.getIVAMonto()));
							sentenciaStore.setLong("Par_PolizaID", Utileria.convierteLong(ingresosOperacionesBean.getPolizaID()));

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", "TarjetaDebitoDAO");

							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}
							return sentenciaStore;

						} //public sql exception
					} // new CallableStatementCreator
					, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}

							return mensajeTransaccion;
						}// public
					}// CallableStatementCallback
					);
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en Cobro Anual de tarjeta de debito", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en Cobro Anual de tarjeta de debito", e);
					}
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}//catch
				return mensajeBean;
			} //public Object doInTransaction
		}); //men
		return mensaje;
	}



	public List TarDebListaCta(int tipoLista,TarjetaDebitoBean tarjetaDebitoBean ) {
		String query = "call TARJETADEBITOLIS(?,?,?,?,    ?    ,?,?, ?,?,?,?);";
		Object[] parametros = {
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				tarjetaDebitoBean.getCuentaAhoID(),
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"TARJETADEBITOLIS.listaTajetasPorCta",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETADEBITOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {

				TarjetaDebitoBean tarjetaDebitoBean= new TarjetaDebitoBean();
				tarjetaDebitoBean.setNombreTarjeta(resultSet.getString(1));
				tarjetaDebitoBean.setRelacion(resultSet.getString(2));
				tarjetaDebitoBean.setEstatus(resultSet.getString(3));
				tarjetaDebitoBean.setTipoTarjetaDebID(resultSet.getString(4));
				return tarjetaDebitoBean;
			}
		});
		return matches;
	}

	//Ejecución SH para el proceso de tarjetas
	public MensajeTransaccionBean procesarArchivoTarjetas(){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		ParamGeneralesBean	paramGeneralesBean = new ParamGeneralesBean();

		//Ejecucion
		try{
			paramGeneralesBean = paramGeneralesServicio.consulta(Enum_Con_ParamGenerales.JobLoteTarjetasSAFI, paramGeneralesBean);
			if(paramGeneralesBean.getValorParametro() == null || paramGeneralesBean.getValorParametro() == Constantes.STRING_VACIO){
				mensaje.setNumero(999);
				mensaje.setDescripcion("Ha ocurrido un Error. No se pudo ejecutar el proceso.");
				mensaje.setNombreControl("loteDebitoSAFIID");
				loggerSAFI.error("No se encuentra configurado la ruta del sh a ejecutar: ");
				return mensaje;
			}

			final String fileSH = paramGeneralesBean.getValorParametro();

			File directorioEjecProceso = new File(fileSH);
			if (!directorioEjecProceso.exists()) {
				loggerSAFI.info(this.getClass()+" - "+"Configure la ruta donde se encuentran los Ejecutables para el proceso de generación de tarjetas.");
				throw new Exception("Configure la ruta donde se encuentran los Ejecutables para el proceso de generación de tarjetas.");
			}

			loggerSAFI.info(this.getClass()+" - "+"Ruta:" + fileSH );

			String[] command = {"sh", fileSH };
			ProcessBuilder pb = new ProcessBuilder();
			pb.command(command);
			Process p = pb.start();
			p.waitFor();

			//Leemos salida del programa
			InputStream is = p.getInputStream();
			InputStreamReader isr = new InputStreamReader(is);
			BufferedReader br = new BufferedReader(isr);
			String line;
			String respuesta = null;
			while ((line = br.readLine()) != null) {
				respuesta = line;
			}

			String[] partes = respuesta.split("-");
			int codigoRespuesta = Integer.parseInt(partes[0]);
			String mensajeRespuesta = partes[1];

			loggerSAFI.info(this.getClass()+" - "+"Respuesta recibida del SH:" + respuesta);

			mensaje.setNumero(codigoRespuesta);
			mensaje.setDescripcion(mensajeRespuesta);
			mensaje.setNombreControl("loteDebitoSAFIID");

		}catch(Exception e){
			e.printStackTrace();
			mensaje.setNumero(999);
			mensaje.setDescripcion("Error al Intentar Ejecutar el Proceso de Generación de Tarjetas.");
			mensaje.setNombreControl("loteDebitoSAFIID");
		}
		return mensaje;
	}

	public TarjetaDebitoBean loteTarjetaRutaArchCon(final int tipoConsulta, TarjetaDebitoBean tarjetaDebitoBean){
		String query = "call LOTETARJETADEBSAFICON(?,?,   ?,?,?,?,?,?,?);";
		Object[] parametros = {

				tarjetaDebitoBean.getLoteDebitoSAFIID(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TarjetaDebitoDAO.loteTarjetaRutaArchCon",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO

				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call LOTETARJETADEBSAFICON(" + Arrays.toString(parametros) +")");
		@SuppressWarnings("unchecked")
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TarjetaDebitoBean tarjetaDebitoBean = new TarjetaDebitoBean();
				tarjetaDebitoBean.setLoteDebitoSAFIID(resultSet.getString("LoteDebSAFIID"));
				tarjetaDebitoBean.setRutaNomArch(resultSet.getString("RutaNomArch"));
				return tarjetaDebitoBean;
			}
		});
		return matches.size() > 0 ? (TarjetaDebitoBean) matches.get(0) : null;
	}

	public ClienteServicio getClienteServicio() {
		return clienteServicio;
	}
	public void setClienteServicio(ClienteServicio clienteServicio) {
		this.clienteServicio = clienteServicio;
	}
	public ParamGeneralesServicio getParamGeneralesServicio() {
		return paramGeneralesServicio;
	}
	public void setParamGeneralesServicio(
			ParamGeneralesServicio paramGeneralesServicio) {
		this.paramGeneralesServicio = paramGeneralesServicio;
	}
}
