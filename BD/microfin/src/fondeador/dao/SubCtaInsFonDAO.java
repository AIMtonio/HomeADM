package fondeador.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import fondeador.bean.SubCtaInstFonBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

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

import java.sql.ResultSetMetaData;

public class SubCtaInsFonDAO extends BaseDAO{

	public SubCtaInsFonDAO() {
		super();
	}
	/* Alta de SubCuenta de Fondeo  */
	public MensajeTransaccionBean alta(final SubCtaInstFonBean subCtaInstFonBean) {

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
							String query = "call SUBCTAINSFONALT(" +
										"?,?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_ConceptoFonID",Utileria.convierteEntero(subCtaInstFonBean.getConceptoFondID()));
							sentenciaStore.setString("Par_TipoFondeador",subCtaInstFonBean.getTipoFondeador());
							sentenciaStore.setInt("Par_InstitutFondID",Utileria.convierteEntero(subCtaInstFonBean.getInstitutFondID()));
							sentenciaStore.setString("Par_SubCuenta",subCtaInstFonBean.getSubCuentaIns());

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							//Parametros de OutPut
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									//Parametros de Auditoria
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
								java.sql.ResultSetMetaData metaDatos;

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
								metaDatos = resultadosStore.getMetaData();
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " SubCtaInsFonDAO.alta");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " SubCtaInsFonDAO.alta");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta SubCuenta por Institución en Fondeo" + e);
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

	/* Modificacion de  Credito Fondeador*/
	public MensajeTransaccionBean modifica(final SubCtaInstFonBean subCtaInstFonBean) {
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
							String query = "call SUBCTAINSFONMOD(" +
										"?,?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_ConceptoFonID",Utileria.convierteEntero(subCtaInstFonBean.getConceptoFondID()));
							sentenciaStore.setString("Par_TipoFondeador",subCtaInstFonBean.getTipoFondeador());
							sentenciaStore.setInt("Par_InstitutFondID",Utileria.convierteEntero(subCtaInstFonBean.getInstitutFondID()));
							sentenciaStore.setString("Par_SubCuenta",subCtaInstFonBean.getSubCuentaIns());
							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							//Parametros de OutPut
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							//Parametros de Auditoria
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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

							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " SubCtaInsFonDAO.modificacion");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);

							}
							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " SubCtaInsFonDAO.modificacion");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en modificacion SubCuenta por institucion en Fondeo" + e);
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
	public MensajeTransaccionBean baja(final SubCtaInstFonBean subCtaInstFonBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call SUBCTAINSFONBAJ(?,?,?,?,	?,?,?,	?,?,?);";
					Object[] parametros = {
							subCtaInstFonBean.getConceptoFondID()	,
							subCtaInstFonBean.getTipoFondeador(),
							subCtaInstFonBean.getInstitutFondID(),

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"SubCtaTiPerAhoDAO.baja",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SUBCTAINSFONBAJ(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum)
								throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));
							return mensaje;
						}
					});
					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de subcuenta por institucion en  fondeo", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	public SubCtaInstFonBean consultaPrincipal(SubCtaInstFonBean subCtaInstFonBean, int tipoConsulta){
		String query = "call SUBCTAINSFONCON(?,?,?,? ,?,?,?, ?,?,?,?);";
		Object[] parametros = {
				subCtaInstFonBean.getConceptoFondID(),
				subCtaInstFonBean.getTipoFondeador(),
				subCtaInstFonBean.getInstitutFondID(),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"SubCtaTipInsFonDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SUBCTAINSFONCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SubCtaInstFonBean subCtaInstFonBean = new SubCtaInstFonBean();
				subCtaInstFonBean.setConceptoFonID(resultSet.getString(1));
				subCtaInstFonBean.setTipoFondeador(resultSet.getString(2));
				subCtaInstFonBean.setInstitutFondID(resultSet.getString(3));
				subCtaInstFonBean.setSubCuenta(resultSet.getString(4));
				return subCtaInstFonBean;
			}
		});
		return matches.size() > 0 ? (SubCtaInstFonBean) matches.get(0) : null;
	}

}
