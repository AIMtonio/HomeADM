package inversiones.dao;
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

import herramientas.Constantes;
import herramientas.Utileria;
import inversiones.bean.CatPromotoresExtInvBean;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;

public class CatPromotoresExtInvDAO extends BaseDAO{

public CatPromotoresExtInvDAO (){
	super();
}
ParametrosSesionBean parametrosSesionBean;
private final static String salidaPantalla = "S";



public MensajeTransaccionBean promotorExtAlta (final CatPromotoresExtInvBean catPromotorExtInvBean) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
	transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
				// Query con el Store Procedur
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "call PROMOTOREXTERNOALT(" +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?,?,?,?, ?);";//parametros de auditoria
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_Nombre",catPromotorExtInvBean.getNombre());
								sentenciaStore.setString("Par_Telefono",catPromotorExtInvBean.getTelefono());
								sentenciaStore.setString("Par_NumCelular",catPromotorExtInvBean.getNumCelular());
								sentenciaStore.setString("Par_Correo",catPromotorExtInvBean.getCorreo());
								sentenciaStore.setString("Par_Estatus",catPromotorExtInvBean.getEstatus());
								sentenciaStore.setString("Par_ExtTelefono",catPromotorExtInvBean.getExtTelefono());

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
									mensajeTransaccion.setDescripcion((resultadosStore.getString(2)));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CatPromotoresExtInvDAO.altaPromotores");
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
						throw new Exception(Constantes.MSG_ERROR + " .CatPromotoresExtInvDAO.altaPromotores");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Promotor Externo" + e);
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



	/*Consulta principal de promotores externos*/
	public CatPromotoresExtInvBean consultaPrincipal(CatPromotoresExtInvBean catPromotorBean, int tipoConsulta){
		String query = "call PROMOTOREXTERNOCON(?,?,?,?,? ,?,?,?,?);";
		Object[] parametros = { catPromotorBean.getNumero(),
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"CatPromotoresExtInvDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROMOTOREXTERNOCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				CatPromotoresExtInvBean promotores = new CatPromotoresExtInvBean();
				promotores.setNumero(resultSet.getString("Numero"));
				promotores.setNombre(resultSet.getString("Nombre"));
				promotores.setTelefono(resultSet.getString("Telefono"));
				promotores.setNumCelular(resultSet.getString("NumCelular"));
				promotores.setCorreo(resultSet.getString("Correo"));
				promotores.setEstatus(resultSet.getString("Estatus"));
				promotores.setExtTelefono(resultSet.getString("ExtTelefono"));
				return promotores;
			}
		});
		return matches.size() > 0 ? (CatPromotoresExtInvBean) matches.get(0) : null;
	}


	// -- Lista de Promotores Externos de Inversiones --//
		public List listaPrincipal(CatPromotoresExtInvBean catPromotoresExtInvBean, int tipoLista) {
			//Query con el Store Procedure
			String query = "call PROMOTOREXTERNOLIS(?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
									catPromotoresExtInvBean.getNumero(),
									Constantes.ENTERO_CERO,
					               tipoLista,
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									parametrosAuditoriaBean.getNombrePrograma(),
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROMOTOREXTERNOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CatPromotoresExtInvBean beneficiariosInver = new CatPromotoresExtInvBean();
					beneficiariosInver.setNumero(resultSet.getString(1));
					beneficiariosInver.setNombre(resultSet.getString("Nombre"));
					return beneficiariosInver;
				}
			});
			return matches;
		}


	/* Modificacion Promotores Externos de Inversiones */

		public MensajeTransaccionBean caPromotorExtInvModifica(final CatPromotoresExtInvBean catPromotoresExtInvBean)  {
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
										String query = "call PROMOTOREXTERNOMOD(?,?,?,?,?,	?,?,?,?,?,"
												   					   + "?,?,?,?,?,	?,?);";
										CallableStatement sentenciaStore = arg0.prepareCall(query);

										sentenciaStore.setString("Par_Numero",catPromotoresExtInvBean.getNumero());
										sentenciaStore.setString("Par_Nombre",catPromotoresExtInvBean.getNombre());
										sentenciaStore.setString("Par_Telefono",catPromotoresExtInvBean.getTelefono());
										sentenciaStore.setString("Par_NumCelular",catPromotoresExtInvBean.getNumCelular());
										sentenciaStore.setString("Par_Correo",catPromotoresExtInvBean.getCorreo());
										sentenciaStore.setString("Par_Estatus",catPromotoresExtInvBean.getEstatus());
										sentenciaStore.setString("Par_ExtTelefono",catPromotoresExtInvBean.getExtTelefono());

										sentenciaStore.setString("Par_Salida",salidaPantalla);
										sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

										sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
										sentenciaStore.setInt("Aud_UsuarioID",parametrosAuditoriaBean.getUsuario());
										sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
										sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
										sentenciaStore.setString("Aud_ProgramaID","InversionDAO.modificaInversion");
										sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
										sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

										loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROMOTOREXTERNOMOD "+ sentenciaStore.toString());
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
											mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CatPromotoresExtInvDAO.promotorExtAlta");
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
								throw new Exception(Constantes.MSG_ERROR + " .CatPromotoresExtInvDAO.promotorExtAlta");
							}else if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						} catch (Exception e) {
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en modificacion de Promotor Externo de Inversiones" + e);
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
