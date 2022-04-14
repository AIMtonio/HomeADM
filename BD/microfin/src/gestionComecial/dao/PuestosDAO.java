package gestionComecial.dao;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import gestionComecial.bean.PuestosBean;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import seguimiento.bean.SegtoRecomendasBean;

public class PuestosDAO extends BaseDAO{

	public PuestosDAO() {
		super();
	}

/*------------Alta de Puestos-------------*/


	public MensajeTransaccionBean alta(final PuestosBean puestosBean) {
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
								String query = "call PUESTOSALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_ClavePuestoID",puestosBean.getClavePuestoID());
								sentenciaStore.setString("Par_Descripcion",puestosBean.getDescripcion());
								sentenciaStore.setString("Par_AtiendeSuc",puestosBean.getAtiendeSuc());
								sentenciaStore.setLong("Par_AreaID",Utileria.convierteLong(puestosBean.getArea()));
								sentenciaStore.setInt("Par_CategoriaID",Utileria.convierteEntero(puestosBean.getCategoriaID()));

								sentenciaStore.setString("Par_EsGestor",puestosBean.getEsGestor());
								sentenciaStore.setString("Par_EsSupervisor",puestosBean.getEsSupervisor());

								sentenciaStore.setString("Par_Salida",	Constantes.salidaSI);
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
						});
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de puestos", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


		/* Modificacion de Puestos */
	public MensajeTransaccionBean modifica(final PuestosBean puestosBean) {
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
								String query = "call PUESTOSMOD(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_ClavePuestoID",puestosBean.getClavePuestoID());
								sentenciaStore.setString("Par_Descripcion",puestosBean.getDescripcion());
								sentenciaStore.setString("Par_AtiendeSuc",puestosBean.getAtiendeSuc());
								sentenciaStore.setLong("Par_AreaID",Utileria.convierteLong(puestosBean.getArea()));
								sentenciaStore.setInt("Par_CategoriaID",Utileria.convierteEntero(puestosBean.getCategoriaID()));

								sentenciaStore.setString("Par_EsGestor",puestosBean.getEsGestor());
								sentenciaStore.setString("Par_EsSupervisor",puestosBean.getEsSupervisor());

								sentenciaStore.setString("Par_Salida",	Constantes.salidaSI);
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
						});
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la modificación de puestos", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


		/*-------Baja de Puestos-------*/

		public MensajeTransaccionBean  baja(final PuestosBean puestosBean) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
		/*--------Baja con SP---------*/
						String query = "call PUESTOSBAJ(?,?,?,?,?,?,?,?,?,?);";
						Object[] parametros = {

								puestosBean.getClavePuestoID(),
								puestosBean.getDescripcion(),
								puestosBean.getAtiendeSuc(),

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()};

						loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PUESTOSBAJ(" + Arrays.toString(parametros) + ")");
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
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de puesto", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}



		public PuestosBean consultaPrincipal(PuestosBean puestos, int tipoConsulta){
			String query = "call PUESTOSCON(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {

					puestos.getClavePuestoID(),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"PuestosDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PUESTOSCON(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PuestosBean puestos = new PuestosBean();
					puestos.setClavePuestoID(resultSet.getString(1));
					puestos.setDescripcion(resultSet.getString(2));
					puestos.setAtiendeSuc(resultSet.getString(3));
					puestos.setArea(resultSet.getString(4));
					puestos.setCategoriaID(resultSet.getString(5));
					puestos.setEsGestor(resultSet.getString(6));
					puestos.setEsSupervisor(resultSet.getString(7));
					return puestos;
				}
			});
			return matches.size() > 0 ? (PuestosBean) matches.get(0) : null;
		}


		public PuestosBean consultaForanea(PuestosBean puestos, int tipoConsulta){
			String query = "call AREASCON(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {

					Utileria.convierteEntero(puestos.getArea()),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"PuestosDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AREASCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PuestosBean puestos = new PuestosBean();
					puestos.setDescripcionArea(resultSet.getString(1));
					return puestos;
				}
			});
			return matches.size() > 0 ? (PuestosBean) matches.get(0) : null;
		}

		public PuestosBean consultaF2(PuestosBean puestos, int tipoConsulta){

			String query = "call CATEGORIAPTOCON(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {

					puestos.getCategoriaID(),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"PuestosDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATEGORIAPTOCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PuestosBean puestos = new PuestosBean();
					puestos.setDescripcionCategoria(resultSet.getString(1));
					return puestos;
				}
			});
			return matches.size() > 0 ? (PuestosBean) matches.get(0) : null;
		}



		public List listaAlfanumerica(PuestosBean puestosBean, int tipoLista){
			String query = "call PUESTOSLIS(?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
						puestosBean.getClavePuestoID(),
						puestosBean.getDescripcion(),
						tipoLista,

						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						"PuestosDAO.listaAlfanumerica",
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PUESTOSLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PuestosBean puestosBean = new PuestosBean();
					puestosBean.setClavePuestoID(resultSet.getString(1));
					puestosBean.setDescripcion(resultSet.getString(2));
					return puestosBean;

				}
			});
			return matches;
			}

		public List listaEjecutivo(PuestosBean puestos, int tipoLista) {
			//Query con el Store Procedure
			String query = "call PUESTOSLIS(?,?,?,  ?,?,?,?,?,?,?);";
			Object[] parametros = {	Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"SeguimientoDAO.listaEjecutivo",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
								};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PUESTOSLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PuestosBean puestos = new PuestosBean();
					puestos.setClavePuestoID(resultSet.getString(1));
					puestos.setDescripcion(resultSet.getString(2));
					return puestos;
				}
			});
			return matches;
		}

		/* Actualización  */
		public MensajeTransaccionBean actualizacion(final PuestosBean puestos) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						//Query cons el Store Procedure
						String query = "call PUESTOSACT(?,?,?,?,?,?,?,?);";
						Object[] parametros = {

								puestos.getClavePuestoID(),

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
								};
						loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PUESTOACT(" + Arrays.toString(parametros) + ")");

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
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizacion de puesto", e);
				}
				return mensajeBean;
				}
			});
			return mensaje;
		}

}
