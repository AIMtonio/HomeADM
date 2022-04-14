package cuentas.dao;

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

import cuentas.bean.AltaPreguntasSeguridadBean;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class AltaPreguntasSeguridadDAO extends BaseDAO{

	public AltaPreguntasSeguridadDAO (){
		super();
	}

	// Alta Preguntas de Seguridad
	public MensajeTransaccionBean altaPreguntasSeguridad(final AltaPreguntasSeguridadBean altaPreguntasSeguridadBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CATPREGUNTASSEGALT(?,?,?,?,?, ?,?,?,?,?,	?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_PreguntaID",Utileria.convierteEntero(altaPreguntasSeguridadBean.getPreguntaID()));
								sentenciaStore.setString("Par_Descripcion",altaPreguntasSeguridadBean.getDescripcion());


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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Alta Preguntas de Seguridad", e);
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

	//Consulta principal Alta Preguntas Seguridad
	public AltaPreguntasSeguridadBean consultaPrincipal(AltaPreguntasSeguridadBean altaPreguntasSeguridadBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CATPREGUNTASSEGCON(?,?,?,?,?,  ?,?,?,?);";
		Object[] parametros = {
								Utileria.convierteEntero(altaPreguntasSeguridadBean.getPreguntaID()),
								tipoConsulta,

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"AltaPreguntasSeguridadDAO.consultaPrincipal",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATPREGUNTASSEGCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AltaPreguntasSeguridadBean bean = new AltaPreguntasSeguridadBean();
				bean.setPreguntaID(resultSet.getString("PreguntaID"));
				bean.setDescripcion(resultSet.getString("Descripcion"));


				return bean;
			}
		});
		return matches.size() > 0 ? (AltaPreguntasSeguridadBean) matches.get(0) : null;
	}

	//Lista Principal Alta Preguntas Seguridad
	public List listaPrincipal(AltaPreguntasSeguridadBean altaPreguntasSeguridadBean, int tipoLista) {
		List AltaPreguntasSeguridadBean = null;
		try{
			//Query con el Store Procedure
			String query = "call CATPREGUNTASSEGLIS(?,?,?,?,?,	?,?,?,?,?);";
			Object[] parametros = {
									altaPreguntasSeguridadBean.getPreguntaID(),
									altaPreguntasSeguridadBean.getDescripcion(),
									tipoLista,

									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"AltaPreguntasSeguridadDAO.listaPrincipal",
									parametrosAuditoriaBean.getSucursal(),
									parametrosAuditoriaBean.getNumeroTransaccion()
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATPREGUNTASSEGLIS(" + Arrays.toString(parametros) +")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					AltaPreguntasSeguridadBean bean = new AltaPreguntasSeguridadBean();

					bean.setPreguntaID(resultSet.getString("PreguntaID"));
					bean.setDescripcion(resultSet.getString("Descripcion"));
					return bean;
				}
			});
			AltaPreguntasSeguridadBean = matches;

		}catch(Exception e){

			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Lista de Alta Preguntas de Seguridad", e);

		}
		return AltaPreguntasSeguridadBean;
	}

}
