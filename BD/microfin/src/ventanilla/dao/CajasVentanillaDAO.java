package ventanilla.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

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
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import ventanilla.bean.CajasTransferBean;
import ventanilla.bean.CajasVentanillaBean;
import ventanilla.bean.IngresosOperacionesBean;
import ventanilla.dao.CajasTransferDAO;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class CajasVentanillaDAO extends BaseDAO{
	CajasTransferDAO cajasTransferDAO= new CajasTransferDAO();
	public CajasVentanillaDAO(){
		super();
	}

	//Alta Cajas Ventanilla
	public MensajeTransaccionBean altaCajasVentanilla(final CajasVentanillaBean cajasVentanillaBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CAJASVENTANILLAALT(?,?,?,?,?, 	?,?,?,?,?, 	?,?,?,?,?, 	?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_TipoCaja",cajasVentanillaBean.getTipoCaja());
								sentenciaStore.setString("Par_UsuarioID",cajasVentanillaBean.getUsuarioID());
								sentenciaStore.setString("Par_DescripCaja",cajasVentanillaBean.getDescripcionCaja());
								sentenciaStore.setString("Par_SucursalID",cajasVentanillaBean.getSucursalID());
								sentenciaStore.setString("Par_LimiteEfec",cajasVentanillaBean.getLimiteEfectivoMN());

								sentenciaStore.setString("Par_LimiteDes",cajasVentanillaBean.getLimiteDesembolsoMN());
								sentenciaStore.setString("Par_MaxRetiro",cajasVentanillaBean.getMaximoRetiroMN());
								sentenciaStore.setString("Par_NomImpresora",cajasVentanillaBean.getNomImpresora());
								sentenciaStore.setString("Par_NomImpresoraCheq",cajasVentanillaBean.getNomImpresoraCheq());
								sentenciaStore.setString("Par_HuellaDigital",cajasVentanillaBean.getHuellaDigital());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de cajas en ventanilla", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	//Actualiza Cajas Ventanilla
	public MensajeTransaccionBean actualizaCajasVentanilla(final CajasVentanillaBean cajasVentanillaBean, final int tipoTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
				//Query cons el Store Procedure
				String query = "call CAJASVENTANILLAACT(?,?,?,?,?, ?,?,?,?,?, "
													 + "?,?,?,?,?, ?,?,?,?,?, "
													 + "?,?,?,?,?, ?,?,?);";
				Object[] parametros = {
						Utileria.convierteEntero(cajasVentanillaBean.getSucursalID()),
						Utileria.convierteEntero(cajasVentanillaBean.getCajaID()),
						cajasVentanillaBean.getTipoCaja(),
						Utileria.convierteEntero(cajasVentanillaBean.getUsuarioID()),
						cajasVentanillaBean.getDescripcionCaja(),

						cajasVentanillaBean.getNomImpresora(),
						cajasVentanillaBean.getNomImpresoraCheq(),
						Constantes.STRING_VACIO,
						cajasVentanillaBean.getFechaCan(),
						cajasVentanillaBean.getMotivoCan(),

						cajasVentanillaBean.getFechaInac(),
						cajasVentanillaBean.getMotivoInac(),
						cajasVentanillaBean.getFechaAct(),
						cajasVentanillaBean.getMotivoAct(),
						Constantes.ENTERO_CERO,

						cajasVentanillaBean.getLimiteEfectivoMN(),
						cajasVentanillaBean.getLimiteDesembolsoMN(),
						cajasVentanillaBean.getMaximoRetiroMN(),
						Constantes.ENTERO_CERO,
						cajasVentanillaBean.getHuellaDigital(),
						tipoTransaccion,

						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						parametrosAuditoriaBean.getNombrePrograma(),
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
				};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CAJASVENTANILLAACT(" + Arrays.toString(parametros)  +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
						mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
						mensaje.setDescripcion(resultSet.getString(2));
						mensaje.setNombreControl(resultSet.getString(3));
						return mensaje;
					}
				});

			return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
			}catch (Exception e) {
				if(mensajeBean.getNumero()==0){
					mensajeBean.setNumero(999);
				}
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+e.getMessage());
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizacion de caja de ventanilla", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	//Actualiza Cajas Ventanilla
	public MensajeTransaccionBean actualizaCajasVentanilla(final CajasVentanillaBean cajasVentanillaBean, final int tipoTransaccion, final long numTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
				//Query cons el Store Procedure
				String query = "call CAJASVENTANILLAACT(?,?,?,?,?, ?,?,?,?,?, "
													 + "?,?,?,?,?, ?,?,?,?,?, "
													 + "?,?,?,?,?, ?,?,?);";
				Object[] parametros = {
						Utileria.convierteEntero(cajasVentanillaBean.getSucursalID()),
						Utileria.convierteEntero(cajasVentanillaBean.getCajaID()),
						cajasVentanillaBean.getTipoCaja(),
						Utileria.convierteEntero(cajasVentanillaBean.getUsuarioID()),
						cajasVentanillaBean.getDescripcionCaja(),

						Constantes.STRING_VACIO,
						Constantes.STRING_VACIO,
						Constantes.STRING_VACIO,
						cajasVentanillaBean.getFechaCan(),
						cajasVentanillaBean.getMotivoCan(),
						cajasVentanillaBean.getFechaInac(),

						cajasVentanillaBean.getMotivoInac(),
						cajasVentanillaBean.getFechaAct(),
						cajasVentanillaBean.getMotivoAct(),
						Constantes.ENTERO_CERO,
						cajasVentanillaBean.getLimiteEfectivoMN(),

						cajasVentanillaBean.getLimiteDesembolsoMN(),
						cajasVentanillaBean.getMaximoRetiroMN(),
						Constantes.ENTERO_CERO,
						Constantes.STRING_VACIO,
						tipoTransaccion,
						parametrosAuditoriaBean.getEmpresaID(),

						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						parametrosAuditoriaBean.getNombrePrograma(),
						parametrosAuditoriaBean.getSucursal(),

						numTransaccion
				};
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
						mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
						mensaje.setDescripcion(resultSet.getString(2));
						mensaje.setNombreControl(resultSet.getString(3));
						return mensaje;
					}
				});

			return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
			}catch (Exception e) {
				if(mensajeBean.getNumero()==0){
					mensajeBean.setNumero(999);
				}
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+e.getMessage());
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean transfiereActualizaCajasVentanilla(final CajasVentanillaBean cajasVentanillaBean, final int tipoTransaccion, final CajasTransferBean cajasTransferBean, final List listaDenominaciones, final String total){
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

				try {
					long numTransaccion;
					// se hace el manejo de la transferencia
					if(listaDenominaciones.size()>0){
						cajasTransferBean.setReferencia(IngresosOperacionesBean.desTRANACaja+": "+Utileria.completaCerosIzquierda(cajasTransferBean.getCajaDestino(),3));
						mensajeBean = cajasTransferDAO.movCajasTransfer(cajasTransferBean,listaDenominaciones, total);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
						numTransaccion = Long.parseLong(mensajeBean.getConsecutivoString());

						// se hace la actualizacion del cierre de caja de atencion al publico no se puede actualizar antes porque el sp DENOMOVSALT tiene validacion por si esta cerrada
						MensajeTransaccionBean mensajeBeanAct = new MensajeTransaccionBean();
						mensajeBeanAct = actualizaCajasVentanilla(cajasVentanillaBean,tipoTransaccion,numTransaccion);
						if(mensajeBeanAct.getNumero()!=0){
							mensajeBean = mensajeBeanAct;
							throw new Exception(mensajeBean.getDescripcion());
						}
						mensajeBean.setNumero(0);
						mensajeBean.setDescripcion("Caja Cerrada Exitosamente.");
						mensajeBean.setNombreControl("numeroTransaccion");
						mensajeBean.setConsecutivoString(String.valueOf(numTransaccion));
						// no se asigna un nuevo numero de auditoria pues el que se necesita para los reportes el el numero de auditoria es el de las transferencias
					}else{
						mensajeBean = actualizaCajasVentanilla(cajasVentanillaBean,tipoTransaccion);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
						mensajeBean.setNumero(0);
						mensajeBean.setDescripcion("Caja Cerrada Exitosamente.");
						mensajeBean.setNombreControl("numeroTransaccion");
						mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));


					}

				} catch (Exception e) {transaccionDAO.generaNumeroTransaccion();

					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+e.getMessage());
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	// PARA CAMBIAR EL ESTATUS DE LA BANDERA A NO

	public MensajeTransaccionBean actualizaEjecProNo(final CajasVentanillaBean cajasVentanillaBean, final int tipoTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
				//Query cons el Store Procedure
				String query = "call CAJASVENTANILLAACT(?,?,?,?,?, ?,?,?,?,?, "
													 + "?,?,?,?,?, ?,?,?,?,?, "
													 + "?,?,?,?,?, ?,?,?);";
				Object[] parametros = {
						Utileria.convierteEntero(cajasVentanillaBean.getSucursalID()),
						Utileria.convierteEntero(cajasVentanillaBean.getCajaID()),
						Constantes.STRING_VACIO,
						Constantes.ENTERO_CERO,
						Constantes.STRING_VACIO,

						Constantes.STRING_VACIO,
						Constantes.STRING_VACIO,
						Constantes.STRING_VACIO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,

						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						Constantes.ENTERO_CERO,

						cajasVentanillaBean.getLimiteEfectivoMN(),
						cajasVentanillaBean.getLimiteDesembolsoMN(),
						cajasVentanillaBean.getMaximoRetiroMN(),
						Constantes.ENTERO_CERO,
						Constantes.STRING_VACIO,
						tipoTransaccion,

						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						parametrosAuditoriaBean.getNombrePrograma(),
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
				};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CAJASVENTANILLAACT(" + Arrays.toString(parametros)  +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
						mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
						mensaje.setDescripcion(resultSet.getString(2));
						return mensaje;
					}
				});

			return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
			}catch (Exception e) {
				if(mensajeBean.getNumero()==0){
					mensajeBean.setNumero(999);
				}
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+e.getMessage());
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizacion de Ejecuta proceso Cajas ventanilla", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método que actualiza el estatus de la Ventanilla para que no se ejecute una operación doble vez en ingreso de Operaciones.
	 * @param cajasVentanillaBean : Bean con la informacion de la Caja a Bloquear
	 * @param tipoTransaccion : Tipo de Actualización
	 * @param origenVentanilla :  Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean actualizaEjecProSi(final CajasVentanillaBean cajasVentanillaBean, final int tipoTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

				try {

					//Query cons el Store Procedure
					String query = "call CAJASVENTANILLAACT(?,?,?,?,?, ?,?,?,?,?, " + "?,?,?,?,?, ?,?,?,?,?, " + "?,?,?,?,?, ?,?,?);";
					Object[] parametros = { Utileria.convierteEntero(cajasVentanillaBean.getSucursalID()), Utileria.convierteEntero(cajasVentanillaBean.getCajaID()), Constantes.STRING_VACIO, Constantes.ENTERO_CERO, Constantes.STRING_VACIO,
					Constantes.STRING_VACIO, Constantes.STRING_VACIO, Constantes.STRING_VACIO, Constantes.FECHA_VACIA, Constantes.STRING_VACIO,
					Constantes.FECHA_VACIA, Constantes.STRING_VACIO, Constantes.FECHA_VACIA, Constantes.STRING_VACIO, Constantes.ENTERO_CERO,
					cajasVentanillaBean.getLimiteEfectivoMN(), cajasVentanillaBean.getLimiteDesembolsoMN(), cajasVentanillaBean.getMaximoRetiroMN(), Constantes.ENTERO_CERO, Constantes.STRING_VACIO, tipoTransaccion,

					parametrosAuditoriaBean.getEmpresaID(), parametrosAuditoriaBean.getUsuario(), parametrosAuditoriaBean.getFecha(), parametrosAuditoriaBean.getDireccionIP(), parametrosAuditoriaBean.getNombrePrograma(), parametrosAuditoriaBean.getSucursal(), parametrosAuditoriaBean.getNumeroTransaccion() };
					if (origenVentanilla) {
						loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call CAJASVENTANILLAACT(" + Arrays.toString(parametros) + ")");
					} else {
						loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call CAJASVENTANILLAACT(" + Arrays.toString(parametros) + ")");
					}
					List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							return mensaje;
						}
					});

					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + e.getMessage());
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en actualizacion de Ejecuta proceso Cajas ventanilla", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	//Consulta principal de Cajas Ventanilla
	public CajasVentanillaBean consultaPrincipal(CajasVentanillaBean cajasVentanillaBean, int tipoConsulta){

		String query = "call CAJASVENTANILLACON(?,?,?,?,?,  ?,?,?,?,?,	?,?);";
		Object[] parametros = {
				cajasVentanillaBean.getCajaID(),
				cajasVentanillaBean.getSucursalID(),
				cajasVentanillaBean.getUsuarioID(),
				cajasVentanillaBean.getTipoCaja(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CajasVentanillaDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CAJASVENTANILLACON(" + Arrays.toString(parametros)  +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CajasVentanillaBean cajasVentanilla = new CajasVentanillaBean();
				cajasVentanilla.setCajaID(resultSet.getString("CajaID"));
				cajasVentanilla.setTipoCaja(resultSet.getString("TipoCaja"));
				cajasVentanilla.setSucursalID(resultSet.getString("SucursalID"));
				cajasVentanilla.setUsuarioID(resultSet.getString("UsuarioID"));
				cajasVentanilla.setDescripcionCaja(resultSet.getString("DescripcionCaja"));
				cajasVentanilla.setLimiteEfectivoMN(resultSet.getString("LimiteEfectivoMN"));
				cajasVentanilla.setEstatus(resultSet.getString("Estatus"));
				cajasVentanilla.setEstatusOpera(resultSet.getString("EstatusOpera"));
				cajasVentanilla.setMotivoCan(resultSet.getString("MotivoCan"));
				cajasVentanilla.setMotivoInac(resultSet.getString("MotivoInac"));
				cajasVentanilla.setMotivoAct(resultSet.getString("MotivoAct"));
				cajasVentanilla.setLimiteDesembolsoMN(resultSet.getString("LimiteDesemMN"));
				cajasVentanilla.setMaximoRetiroMN(resultSet.getString("MaximoRetiroMN"));
				cajasVentanilla.setTipoCajaID(resultSet.getString("TipoCajaID"));
				cajasVentanilla.setNomImpresora(resultSet.getString("NomImpresora"));
				cajasVentanilla.setNomImpresoraCheq(resultSet.getString("NomImpresoraCheq"));
				cajasVentanilla.setHuellaDigital(resultSet.getString("HuellaDigital"));


				return cajasVentanilla;
			}
		});
		return matches.size() > 0 ? (CajasVentanillaBean) matches.get(0) : null;

	}

	public CajasVentanillaBean consultaCajaPrincipalEO(CajasVentanillaBean cajasVentanillaBean, int tipoConsulta){

		String query = "call CAJASVENTANILLACON(?,?,?,?,?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(cajasVentanillaBean.getCajaID()),
				Utileria.convierteEntero(cajasVentanillaBean.getSucursalID()),
				0,
				"",
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CajasVentanillaDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+parametros);
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CajasVentanillaBean cajasVentanilla = new CajasVentanillaBean();
				cajasVentanilla.setCajaID(String.valueOf(resultSet.getString("CajaID")));
				cajasVentanilla.setEstatusOpera(resultSet.getString("EstatusOpera"));
				return cajasVentanilla;
			}
		});
		return matches.size() > 0 ? (CajasVentanillaBean) matches.get(0) : null;

	}

	// CONSULTA PARA OBTENER EL LIMITE DE CREDITO Y EL SALDO
	public CajasVentanillaBean consultaSaldosCaja(CajasVentanillaBean cajasVentanillaBean, int tipoConsulta){
		CajasVentanillaBean cajasBeanConsulta = new CajasVentanillaBean();

		try{
			String query = "call CAJASVENTANILLACON(?,?,?,?,?,  ?,?,?,?,?,?,?);";
			Object[] parametros = {
					cajasVentanillaBean.getCajaID(),
					cajasVentanillaBean.getSucursalID(),
					cajasVentanillaBean.getUsuarioID(),
					cajasVentanillaBean.getTipoCaja(),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CajasVentanillaDAO.conSaldoCaja",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
				};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CAJASVENTANILLACON(" + Arrays.toString(parametros)  +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CajasVentanillaBean cajasVentanilla = new CajasVentanillaBean();
					cajasVentanilla.setSaldoEfecMN(resultSet.getString(1));
					cajasVentanilla.setSaldoEfecME(resultSet.getString(2));
					cajasVentanilla.setLimiteEfectivoMN(resultSet.getString(3));
					cajasVentanilla.setEstatus(resultSet.getString(4));

					return cajasVentanilla;
				}
			});
			cajasBeanConsulta= matches.size() > 0 ? (CajasVentanillaBean) matches.get(0) : null;
		}catch(Exception e){
//			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+e.getMessage());
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta principal de caja en ventanilla", e);
		}
		return cajasBeanConsulta;
	}

//	public CajasVentanillaBean consultaSaldos(CajasVentanillaBean cajasVentanillaBean, int tipoConsulta){
//		CajasVentanillaBean cajasBeanConsulta = new CajasVentanillaBean();
//
//		try{
//			String query = "call CAJASVENTANILLACON(?,?,?,?,?,  ?,?,?,?,?,?,?);";
//			Object[] parametros = {
//					cajasVentanillaBean.getCajaID(),
//					Constantes.ENTERO_CERO,
//					Constantes.ENTERO_CERO,
//					Constantes.STRING_VACIO,
//					tipoConsulta,
//
//					Constantes.ENTERO_CERO,
//					Constantes.ENTERO_CERO,
//					Constantes.FECHA_VACIA,
//					Constantes.STRING_VACIO,
//					"CajasVentanillaDAO.conSaldoCaja",
//					Constantes.ENTERO_CERO,
//					Constantes.ENTERO_CERO
//				};
//			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CAJASVENTANILLACON(" + Arrays.toString(parametros)  +")");
//			List matches=jdbcTemplate.query(query, parametros, new RowMapper() {
//				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
//					CajasVentanillaBean cajasVentanilla = new CajasVentanillaBean();
//					cajasVentanilla.setSaldoEfecMN(resultSet.getString(1));
//					cajasVentanilla.setSaldoEfecME(resultSet.getString(2));
//					cajasVentanilla.setLimiteEfectivoMN(resultSet.getString(3));
//					cajasVentanilla.setEstatus(resultSet.getString(4));
//					loggerSAFI.debug("resultSet.getString(1) "+resultSet.getString(1) + "  resultSet.getString(2) "+resultSet.getString(2)+"" +
//										"  resultSet.getString(3)  "+resultSet.getString(3)+ "   resultSet.getString(4) "+resultSet.getString(4));
//					return cajasVentanilla;
//				}
//			});
//			cajasBeanConsulta= matches.size() > 0 ? (CajasVentanillaBean) matches.get(0) : null;
//		}catch(Exception e){
////			e.printStackTrace();
//			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+e.getMessage());
//			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta principal de caja en ventanilla", e);
//		}
//		return cajasBeanConsulta;
//	}


	//Lista Cajas Ventanilla
	public List listaPrincipal(CajasVentanillaBean cajasVentanillaBean,int tipoLista, String sucursalOrigen){
		String query = "call CAJASVENTANILLALIS(?,?,?,?,?, ?,?,?,?,?,	?,?,?,?,?);";
		Object[] parametros = {
				cajasVentanillaBean.getCajaID(),
				Utileria.convierteEntero(cajasVentanillaBean.getSucursalID()),
				cajasVentanillaBean.getTipoCaja(),
				Utileria.convierteEntero(sucursalOrigen),
				(cajasVentanillaBean.getCajaIDOrigen()== null) ? 0 : Utileria.convierteEntero(cajasVentanillaBean.getCajaIDOrigen()),

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,

				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CAJASVENTANILLALIS(" + Arrays.toString(parametros)  +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CajasVentanillaBean cajasVentanilla = new CajasVentanillaBean();
				cajasVentanilla.setCajaID(resultSet.getString(1));
				cajasVentanilla.setTipoCaja(resultSet.getString(2));
				cajasVentanilla.setDescripcionCaja(resultSet.getString(3));
				return cajasVentanilla;
			}
		});
		return matches;
	}

	//Lista Cajas para pantalla tesoreria
	public List listaCajasGrid(CajasVentanillaBean cajasVentanillaBean,int tipoLista){
		List chequesSucur = null;
		try{
			String query = "call CAJASVENTANILLALIS(?,?,?,?,?, ?,?,?,?,?,	?,?,?,?,?);";
			Object[] parametros = {
					Constantes.STRING_VACIO,
					cajasVentanillaBean.getSucursalID(),
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					cajasVentanillaBean.getInstitucionID(),

					cajasVentanillaBean.getNumCtaInstit(),
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CAJASVENTANILLALIS(" + Arrays.toString(parametros)  +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CajasVentanillaBean cajasVentanillaBean = new CajasVentanillaBean();
					cajasVentanillaBean.setCajaID(resultSet.getString(1));
					cajasVentanillaBean.setSucursalID(resultSet.getString(2));
					cajasVentanillaBean.setTipoCaja(resultSet.getString(3));
					cajasVentanillaBean.setEstatus(resultSet.getString(4));
					return cajasVentanillaBean;
				}
			});
			chequesSucur= matches;
		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de asignacion de cheque a sucursal", e);
		}
			return chequesSucur;
	}

	//Lista Arqueo de Caja
	public List arqueoCaja(CajasVentanillaBean cajasVentanillaBean,int tipoLista){
		String query = "call CAJASARQUEOLIS(?,?,?,?,  ?,?,?, ?,?,? ,?);";
		Object[] parametros = {
				cajasVentanillaBean.getSucursalID(),
				cajasVentanillaBean.getCajaID(),
				cajasVentanillaBean.getFecha(),
				cajasVentanillaBean.getNaturaleza(),

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CAJASARQUEOLIS(" + Arrays.toString(parametros)  +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CajasVentanillaBean cajasVentanilla = new CajasVentanillaBean();
				cajasVentanilla.setMovimiento(resultSet.getString(1));
				cajasVentanilla.setNoMovimiento(resultSet.getString(2));
				cajasVentanilla.setMontoTotal(resultSet.getString(3));
				cajasVentanilla.setNaturaleza(resultSet.getString(4));
				cajasVentanilla.setNumeroNat(resultSet.getString(5));
				return cajasVentanilla;
			}
		});
		return matches;
	}



	//Lista que devuelve el historico de caja arqueo

	public List arqueoCajaHis( CajasVentanillaBean cajasVentanillaBean, int tipoLista){

			String query = "call `HIS-CAJASARQUEOLIS`(?,?,?,?,  ?,?,?, ?,?,? ,?,?);";
			Object[] parametros = {
					cajasVentanillaBean.getSucursalID(),
					cajasVentanillaBean.getCajaID(),
					cajasVentanillaBean.getFecha(),
					cajasVentanillaBean.getNaturaleza(),
				    tipoLista,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call `HIS-CAJASARQUEOLIS`(" + Arrays.toString(parametros)  +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CajasVentanillaBean cajasVentanilla = new CajasVentanillaBean();
					cajasVentanilla.setMovimiento(resultSet.getString(1));
					cajasVentanilla.setNoMovimiento(resultSet.getString(2));
					cajasVentanilla.setMontoTotal(resultSet.getString(3));
					cajasVentanilla.setNaturaleza(resultSet.getString(4));
					cajasVentanilla.setNumeroNat(resultSet.getString(5));
					return cajasVentanilla;
				}
			});
			return matches;
		}
	public List cajaCombo(int tipoLista, CajasVentanillaBean cajasVentanillaBean){
		String query = "call CAJASVENTANILLALIS(?,?,?,?,?, ?,?,?,?,?,	?,?,?,?,?);";
		Object[] parametros = {
				(cajasVentanillaBean.getEstatusOpera() != null) ? cajasVentanillaBean.getEstatusOpera(): Constantes.STRING_VACIO,
				(cajasVentanillaBean.getCajaID() !=null)? Integer.valueOf(cajasVentanillaBean.getCajaID()) : Constantes.ENTERO_CERO,
				(cajasVentanillaBean.getTipoCaja() != null) ? cajasVentanillaBean.getTipoCaja() :Constantes.STRING_VACIO,
				(cajasVentanillaBean.getSucursalID() != null) ? Integer.valueOf(cajasVentanillaBean.getSucursalID()): Constantes.ENTERO_CERO,
				(cajasVentanillaBean.getCajaIDOrigen()== null) ? 0 : Utileria.convierteEntero(cajasVentanillaBean.getCajaIDOrigen()),
				Constantes.ENTERO_CERO,

				Constantes.ENTERO_CERO,
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,

				Constantes.STRING_VACIO,
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CajasVentanillaBean cajasVentanilla = new CajasVentanillaBean();
				cajasVentanilla.setCajaID(resultSet.getString(1));
				cajasVentanilla.setDescripcionCaja(resultSet.getString(2));
				return cajasVentanilla;
			}
		});
		return matches;
	}

	public List listaCajasSucursal(int tipoLista, CajasVentanillaBean cajasVentanillaBean){

		String query = "call CAJASVENTANILLALIS(?,?,?,?,?, ?,?,?,?,?,	?,?,?,?,?);";
		Object[] parametros = {
				(cajasVentanillaBean.getEstatusOpera() != null) ? cajasVentanillaBean.getEstatusOpera(): Constantes.STRING_VACIO,
				(cajasVentanillaBean.getCajaID() !=null)? Integer.valueOf(cajasVentanillaBean.getCajaID()) : Constantes.ENTERO_CERO,
				(cajasVentanillaBean.getTipoCaja() != null) ? cajasVentanillaBean.getTipoCaja() :Constantes.STRING_VACIO,
				(cajasVentanillaBean.getSucursalID() != null) ? Integer.valueOf(cajasVentanillaBean.getSucursalID()): Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,

				Constantes.ENTERO_CERO,
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CajasVentanillaBean cajasVentanilla = new CajasVentanillaBean();
				cajasVentanilla.setCajaID(resultSet.getString(1));
				cajasVentanilla.setDescripcionCaja(resultSet.getString(2));
				return cajasVentanilla;
			}
		});
		return matches;
	}

	//LISTA DE TIRA AUDITORA
	public List arqTicket(CajasVentanillaBean cajasVentanillaBean,int tipoLista){
		String query = "call CAJASARQTICKETREP(?,?,?,?,?, ?,?,?, ?,?);";
		Object[] parametros = {
				cajasVentanillaBean.getSucursalID(),
				cajasVentanillaBean.getCajaID(),
				cajasVentanillaBean.getFecha(),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CAJASARQTICKETREP(" + Arrays.toString(parametros)  +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CajasVentanillaBean cajasVentanilla = new CajasVentanillaBean();
				cajasVentanilla.setDescCorta(resultSet.getString(1));
				cajasVentanilla.setTipo(resultSet.getString(2));
				cajasVentanilla.setEstilo(resultSet.getString(3));
				return cajasVentanilla;
			}
		});
		return matches;
	}


	//lista para impresion de tira auditora en ticket del historico
	public List arqTicketHis(CajasVentanillaBean cajasVentanillaBean,int tipoLista){
		String query = "call CAJASARQTICKETREPHIS(?,?,?,?,?, ?,?,?, ?,?);";
		Object[] parametros = {
				cajasVentanillaBean.getSucursalID(),
				cajasVentanillaBean.getCajaID(),
				cajasVentanillaBean.getFecha(),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CAJASARQTICKETREPHIS(" + Arrays.toString(parametros)  +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CajasVentanillaBean cajasVentanilla = new CajasVentanillaBean();
				cajasVentanilla.setDescCorta(resultSet.getString(1));
				cajasVentanilla.setTipo(resultSet.getString(2));
				cajasVentanilla.setEstilo(resultSet.getString(3));
				return cajasVentanilla;
			}
		});
		return matches;
	}


	// lista para impresion en ticket de detalles en tira auditora
	public List detTicket(CajasVentanillaBean cajasVentanillaBean,int tipoLista){
		String query = "call DETMOVCAJATICKREP(?,?,?,?, ?,?,?, ?,?,?, ?);";
		Object[] parametros = {
				cajasVentanillaBean.getSucursalID(),
				cajasVentanillaBean.getCajaID(),
				cajasVentanillaBean.getFecha(),
				cajasVentanillaBean.getTipoOperacion(),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DETMOVCAJATICKREP(" + Arrays.toString(parametros)  +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CajasVentanillaBean cajasVentanilla = new CajasVentanillaBean();
				cajasVentanilla.setDescCorta(resultSet.getString(1));
				cajasVentanilla.setTipo(resultSet.getString(2));
				cajasVentanilla.setEstilo(resultSet.getString(3));
				return cajasVentanilla;
			}
		});
		return matches;
	}

	// GENERA EL TICKET EN DETALLES DEL HISTORICO DE LA TIRA AUDITORA
	public List detTicketHis(CajasVentanillaBean cajasVentanillaBean,int tipoLista){
		String query = "call DETMOVCAJATICKHIS(?,?,?,?, ?,?,?, ?,?,?, ?);";
		Object[] parametros = {
				cajasVentanillaBean.getSucursalID(),
				cajasVentanillaBean.getCajaID(),
				cajasVentanillaBean.getFecha(),
				cajasVentanillaBean.getTipoOperacion(),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DETMOVCAJATICKHIS(" + Arrays.toString(parametros)  +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CajasVentanillaBean cajasVentanilla = new CajasVentanillaBean();
				cajasVentanilla.setDescCorta(resultSet.getString(1));
				cajasVentanilla.setTipo(resultSet.getString(2));
				cajasVentanilla.setEstilo(resultSet.getString(3));
				return cajasVentanilla;
			}
		});
		return matches;
	}
	//CONSULTA PARA DISPONIBLE POR DENOMINACION EN EL HISTORICO
	public List  hisBalanceCon(final int tipo, final CajasVentanillaBean cajasVentanillaBean){
		List listIngresosOperacionesBean = null ;
		try{

			//Query con el Store Procedure
			String query = "call `HIS-BALANZADENOLIS`(?,?,?,?,?, ?,?,?,?,?, ?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(cajasVentanillaBean.getSucursalID()),
					Utileria.convierteEntero(cajasVentanillaBean.getCajaID()),
					Constantes.ENTERO_CERO,
					Utileria.convierteEntero(cajasVentanillaBean.getMonedaID()),
					cajasVentanillaBean.getFecha(),

					tipo,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,

					"CajasVentanillaDAO.hisBalance",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CajasVentanillaBean cajasVentanillaBean = new CajasVentanillaBean();
					cajasVentanillaBean.setSucursalID(resultSet.getString(1));
					cajasVentanillaBean.setCajaID(resultSet.getString(2));
					cajasVentanillaBean.setDenominacionID(resultSet.getString(3));
					cajasVentanillaBean.setCantidadDenominacion(resultSet.getString(4));
					return cajasVentanillaBean;
				}
			});
			listIngresosOperacionesBean= matches;
		}catch(Exception e){
			e.printStackTrace();
		}
		return listIngresosOperacionesBean;
	}



	//CONSULTA PARA DISPONIBLE POR DENOMINACION EN EL HISTORICO
	public List  hisBalanceLis(final CajasVentanillaBean cajasVentanillaBean){
		List listIngresosOperacionesBean = null ;
		try{

			//Query con el Store Procedure
			String query = "call `HIS-BALANZADENOLIS`(?,?,?,?,?, ?,?,?,?,?, ?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(cajasVentanillaBean.getSucursalID()),
					Utileria.convierteEntero(cajasVentanillaBean.getCajaID()),
					Constantes.ENTERO_CERO,
					Utileria.convierteEntero(cajasVentanillaBean.getMonedaID()),
					cajasVentanillaBean.getFecha(),

					2,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,

					"CajasVentanillaDAO.hisBalance",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			this.loggerSAFI.debug(parametrosAuditoriaBean.getOrigenDatos()+"-"+query);
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();
					ingresosOperacionesBean.setFecha(resultSet.getString(1));
					return ingresosOperacionesBean;
				}
			});
			listIngresosOperacionesBean= matches;
		}catch(Exception e){
			e.printStackTrace();
		}
		return listIngresosOperacionesBean;
	}

	// ------------ reporte opVentanilla
	public List consultaOpVentanilla(final CajasVentanillaBean cajasVentanillaBean){

		List listaOpVentanilla=null;
		List matches =new  ArrayList();
		final List matches2 =new  ArrayList();
		try{
		matches =(List) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new CallableStatementCreator() {
			public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call OPERACIONESVENTREP(" +
						"?,?,?,?,?, ?,?,?,?,?,?,?);";
				CallableStatement sentenciaStore = arg0.prepareCall(query);
				sentenciaStore.setString("Par_FechaIni",cajasVentanillaBean.getFechaIni());
				sentenciaStore.setString("Par_FechaFin",cajasVentanillaBean.getFechaFin());
				sentenciaStore.setInt("Par_Sucursal",Utileria.convierteEntero(cajasVentanillaBean.getSucursalID()));
				sentenciaStore.setInt("Par_Caja",Utileria.convierteEntero(cajasVentanillaBean.getCajaID()));
				sentenciaStore.setInt("Par_Naturaleza",Utileria.convierteEntero(cajasVentanillaBean.getNaturaleza()));

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
				public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
					if(callableStatement.execute()){
						ResultSet resultadosStore = callableStatement.getResultSet();
						while (resultadosStore.next()) {
							CajasVentanillaBean cajasVentanillaBean	=new CajasVentanillaBean();
							cajasVentanillaBean.setNumTransaccion(resultadosStore.getString(1));
							cajasVentanillaBean.setFecha(resultadosStore.getString(2));
							cajasVentanillaBean.setDescripcionCaja(resultadosStore.getString(3));
							cajasVentanillaBean.setSucursal(resultadosStore.getString(4));
							cajasVentanillaBean.setEfectivo(String.valueOf(resultadosStore.getDouble(5)));
							cajasVentanillaBean.setMontoSBC(String.valueOf(resultadosStore.getDouble(6)));
							cajasVentanillaBean.setNumCuenta(resultadosStore.getString(7));
							cajasVentanillaBean.setClienteID(String.valueOf(resultadosStore.getString(10)));
							cajasVentanillaBean.setNombreCliente(resultadosStore.getString(11));
							cajasVentanillaBean.setReferencia(resultadosStore.getString(12));
							cajasVentanillaBean.setNaturaleza(String.valueOf(resultadosStore.getInt(15)));
							cajasVentanillaBean.setPolizaID(String.valueOf(resultadosStore.getInt(17)));
							cajasVentanillaBean.setGrupoCred(resultadosStore.getString(18));

						matches2.add(cajasVentanillaBean);
					}
				}
				return matches2;
			}
			});
				}catch(Exception e){
					e.printStackTrace();
					}
		return matches;

		}

		// ------------ reporte opVentanilla
		public List consultaOpVentanillaComer(final CajasVentanillaBean cajasVentanillaBean){
			List matches =new  ArrayList();
			final List matches2 =new  ArrayList();
			try{
				matches =(List) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
new CallableStatementCreator() {
				public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
					String query = "call OPERAVENTANILLACOMERREP(" +
							"?,?,?,?,?, ?,?,?,?,?,?,?);";
					CallableStatement sentenciaStore = arg0.prepareCall(query);
					sentenciaStore.setString("Par_FechaIni",cajasVentanillaBean.getFechaIni());
					sentenciaStore.setString("Par_FechaFin",cajasVentanillaBean.getFechaFin());
					sentenciaStore.setInt("Par_Sucursal",Utileria.convierteEntero(cajasVentanillaBean.getSucursalID()));
					sentenciaStore.setInt("Par_Caja",Utileria.convierteEntero(cajasVentanillaBean.getCajaID()));
					sentenciaStore.setInt("Par_Naturaleza",Utileria.convierteEntero(cajasVentanillaBean.getNaturaleza()));

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
					public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
						if(callableStatement.execute()){
							ResultSet resultadosStore = callableStatement.getResultSet();
							while (resultadosStore.next()) {
								CajasVentanillaBean cajasVentanillaBean	=new CajasVentanillaBean();
								cajasVentanillaBean.setNumTransaccion(resultadosStore.getString("Transaccion"));
								cajasVentanillaBean.setCajaID(resultadosStore.getString("CajaID"));
								cajasVentanillaBean.setDescripcionCaja(resultadosStore.getString("DescripcionCaja"));
								cajasVentanillaBean.setFecha(resultadosStore.getString("Fecha"));
								cajasVentanillaBean.setMontoTotal(resultadosStore.getString("MontoEnFirme"));
								cajasVentanillaBean.setTipoOperacion(resultadosStore.getString("TipoOperacion"));
								cajasVentanillaBean.setSucursal(resultadosStore.getString("Sucursal"));
								cajasVentanillaBean.setNombreSucursal(resultadosStore.getString("NombreSucurs"));
								cajasVentanillaBean.setDescCorta(resultadosStore.getString("Descripcion"));
								cajasVentanillaBean.setDescripcionCaja(resultadosStore.getString("DescripcionRef"));
								cajasVentanillaBean.setNaturaleza(resultadosStore.getString("Naturaleza"));
								cajasVentanillaBean.setPolizaID(String.valueOf(resultadosStore.getInt("PolizaID")));
								cajasVentanillaBean.setInstrumento(resultadosStore.getString("Instrumento"));
								cajasVentanillaBean.setTipoInstrumentoID(resultadosStore.getString("TipoInstrumentoID"));
								cajasVentanillaBean.setMontoOperacion(resultadosStore.getString("MontoOperac"));
								cajasVentanillaBean.setMontoDeposito(resultadosStore.getString("MontoDeposito"));
								cajasVentanillaBean.setMontoCambio(resultadosStore.getString("MontoCambio"));
								cajasVentanillaBean.setClienteID(String.valueOf(resultadosStore.getString("ClienteID")));
								cajasVentanillaBean.setNombreCliente(resultadosStore.getString("NombreCompleto"));
								cajasVentanillaBean.setGrupoCred(resultadosStore.getString("NombreGrupo"));
								cajasVentanillaBean.setDiferenciaMontos(resultadosStore.getString("DiferenciaMontos"));

							    matches2.add(cajasVentanillaBean);
						}
					}
					return matches2;
				}
				});
					}catch(Exception e){
						e.printStackTrace();
						}
			return matches;

			}

	public CajasTransferDAO getCajasTransferDAO() {
		return cajasTransferDAO;
	}

	public void setCajasTransferDAO(CajasTransferDAO cajasTransferDAO) {
		this.cajasTransferDAO = cajasTransferDAO;
	}
}
