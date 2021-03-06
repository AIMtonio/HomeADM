package ventanilla.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

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
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import ventanilla.bean.CatalogoRemesasBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;

public class CatalogoRemesasDAO extends BaseDAO{
	public CatalogoRemesasDAO(){
		super();
	}

	//Alta Remesas Ventanilla
	public MensajeTransaccionBean altaCatalogoRemesas(final CatalogoRemesasBean catalogoRemesasBean){
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
								String query = "call REMESACATALOGOALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?" +
										");";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_Nombre",catalogoRemesasBean.getNombre());
								sentenciaStore.setString("Par_NombreCorto",catalogoRemesasBean.getNombreCorto());
								sentenciaStore.setString("Par_CuentaCompleta",catalogoRemesasBean.getCuentaCompleta());
								sentenciaStore.setString("Par_CentroCostos",catalogoRemesasBean.getcCostosRemesa());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de Remesas en ventanilla", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	//Modificacion Remesas Ventanilla
		public MensajeTransaccionBean modificacionCatalogoRemesas(final CatalogoRemesasBean catalogoRemesasBean){
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
									String query = "call REMESACATALOGOMOD(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_RemesaCatalogoID",catalogoRemesasBean.getRemesaCatalogoID());
									sentenciaStore.setString("Par_Nombre",catalogoRemesasBean.getNombre());
									sentenciaStore.setString("Par_NombreCorto",catalogoRemesasBean.getNombreCorto());
									sentenciaStore.setString("Par_CuentaCompleta",catalogoRemesasBean.getCuentaCompleta());
									sentenciaStore.setString("Par_CentroCostos",catalogoRemesasBean.getcCostosRemesa());
									sentenciaStore.setString("Par_Estatus",catalogoRemesasBean.getEstatus());
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificaci??n de Remesas en ventanilla", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

	//Consulta principal de Cajas Ventanilla
	public CatalogoRemesasBean consultaPrincipal(CatalogoRemesasBean catalogoRemesasBean, int tipoConsulta){

		String query = "call REMESACATALOGOCON(?,?,  ?,?,?,?,?,	?,?);";
		Object[] parametros = {

				catalogoRemesasBean.getRemesaCatalogoID(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CajasVentanillaDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REMESACATALOGOCON(" + Arrays.toString(parametros)  +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CatalogoRemesasBean catalogoRemesas = new CatalogoRemesasBean();
				catalogoRemesas.setRemesaCatalogoID(resultSet.getString("RemesaCatalogoID"));
				catalogoRemesas.setNombre(resultSet.getString("Nombre"));
				catalogoRemesas.setNombreCorto(resultSet.getString("NombreCorto"));
				catalogoRemesas.setCuentaCompleta(resultSet.getString("CuentaCompleta"));
				catalogoRemesas.setcCostosRemesa(resultSet.getString("CCostosRemesa"));
				catalogoRemesas.setEstatus(resultSet.getString("Estatus"));

				return catalogoRemesas;
			}
		});
		return matches.size() > 0 ? (CatalogoRemesasBean) matches.get(0) : null;

	}

	//Lista Cajas Ventanilla
	public List listaPrincipal(CatalogoRemesasBean catalogoRemesasBean,int tipoLista){
		String query = "call REMESACATALOGOLIS(?,?,	?,?,?,?,?,?,?);";
		Object[] parametros = {
				catalogoRemesasBean.getNombre(),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REMESACATALOGOLIS(" + Arrays.toString(parametros)  +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CatalogoRemesasBean catalogoRemesas = new CatalogoRemesasBean();
				catalogoRemesas.setRemesaCatalogoID(resultSet.getString("RemesaCatalogoID"));
				catalogoRemesas.setNombre(resultSet.getString("Nombre"));
				catalogoRemesas.setNombreCorto(resultSet.getString("NombreCorto"));
				catalogoRemesas.setCuentaCompleta(resultSet.getString("CuentaCompleta"));
				return catalogoRemesas;
			}
		});
		return matches;
	}

	//Lista Cajas Ventanilla
		public List listaCombo(CatalogoRemesasBean catalogoRemesasBean,int tipoLista){
			String query = "call REMESACATALOGOLIS(?,?,	?,?,?,?,?,?,?);";
			Object[] parametros = {
					Constantes.STRING_VACIO,
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REMESACATALOGOLIS(" + Arrays.toString(parametros)  +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CatalogoRemesasBean catalogoRemesas = new CatalogoRemesasBean();
					catalogoRemesas.setRemesaCatalogoID(resultSet.getString("RemesaCatalogoID"));
					catalogoRemesas.setNombre(resultSet.getString("Nombre"));
					catalogoRemesas.setNombreCorto(resultSet.getString("NombreCorto"));
					catalogoRemesas.setCuentaCompleta(resultSet.getString("CuentaCompleta"));
					return catalogoRemesas;
				}
			});
			return matches;
		}
}
