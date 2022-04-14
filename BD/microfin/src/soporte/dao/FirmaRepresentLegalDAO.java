package soporte.dao;
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

import cliente.bean.ClienteArchivosBean;
import soporte.bean.FirmaRepresentLegalBean;
import soporte.servicio.ParametrosSisServicio;
import general.bean.MensajeTransaccionArchivoBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class FirmaRepresentLegalDAO extends BaseDAO{
		ParametrosSisServicio parametrosSisServicio=null;
		public FirmaRepresentLegalDAO(){
			super();
		}

		public MensajeTransaccionArchivoBean altaArchivosFirma(final FirmaRepresentLegalBean firmaBean){
			MensajeTransaccionArchivoBean mensaje= new MensajeTransaccionArchivoBean();
			transaccionDAO.generaNumeroTransaccion();
			mensaje = (MensajeTransaccionArchivoBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionArchivoBean mensajeBean = new MensajeTransaccionArchivoBean();
					try {
						mensajeBean = (MensajeTransaccionArchivoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
								new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call FIRMAREPLEGALALT(?,?,?,?,?, 	?,?,?,?,?," +
																	 "?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_RepresentLegal",firmaBean.getRepresentLegal());
								sentenciaStore.setString("Par_Recurso",firmaBean.getRecurso());
								sentenciaStore.setString("Par_Observacion",firmaBean.getObservacion());
								sentenciaStore.setString("Par_Extension",firmaBean.getExtension());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID","FirmaRepresentLegalDAO.altaArchivosFirma");
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
					 	},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionArchivoBean mensajeTransaccionArchivoBean = new MensajeTransaccionArchivoBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccionArchivoBean.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccionArchivoBean.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccionArchivoBean.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccionArchivoBean.setConsecutivoString(resultadosStore.getString(4));
									mensajeTransaccionArchivoBean.setRecursoOrigen(resultadosStore.getString(5));
								}else{
									mensajeTransaccionArchivoBean.setNumero(999);
									mensajeTransaccionArchivoBean.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccionArchivoBean;
							}
						});
						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionArchivoBean();
							mensajeBean.setNumero(999);
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de Firma Representante Legal" + e);
						e.printStackTrace();
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}


		public MensajeTransaccionArchivoBean bajaDeFirma(final FirmaRepresentLegalBean firmaBean){
			MensajeTransaccionArchivoBean mensaje= new MensajeTransaccionArchivoBean();
			mensaje = (MensajeTransaccionArchivoBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionArchivoBean mensajeBean = new MensajeTransaccionArchivoBean();
					try {
						mensajeBean = (MensajeTransaccionArchivoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
								new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call FIRMAREPLEGALBAJ(?,?,?,?,?, 	?,?,?,?,?,	 ?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_RepresentLegal",firmaBean.getRepresentLegal());
								sentenciaStore.setString("Par_Consecutivo",firmaBean.getConsecutivo());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
								sentenciaStore.setString("Aud_FechaActual", Constantes.FECHA_VACIA);
								sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
								sentenciaStore.setString("Aud_ProgramaID","FirmaRepresentLegalDAO.altaArchivosFirma");
								sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
								sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
					 	},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionArchivoBean mensajeTransaccionArchivoBean = new MensajeTransaccionArchivoBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccionArchivoBean.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccionArchivoBean.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccionArchivoBean.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccionArchivoBean.setConsecutivoString(resultadosStore.getString(4));
								}else{
									mensajeTransaccionArchivoBean.setNumero(999);
									mensajeTransaccionArchivoBean.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccionArchivoBean;
							}
						});
						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionArchivoBean();
							mensajeBean.setNumero(999);
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Baja de Firma Representante Legal" + e);
						e.printStackTrace();
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

		/* Lista de Archivos de la firma del representante legal*/
		public List firmasArchivoGrid(FirmaRepresentLegalBean firmaBean, int tipoLista) {
			//Query con el Store Procedure
			String query = "call FIRMAREPLEGALLIS(?,?,?,?,?, ?,?,?,?);";
			Object[] parametros = {
					firmaBean.getRepresentLegal(),
					tipoLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"firmasArchivoGrid",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FIRMAREPLEGALLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					FirmaRepresentLegalBean firmaLegalBean = new FirmaRepresentLegalBean();
					firmaLegalBean.setRepresentLegal(resultSet.getString("RepresentLegal"));
					firmaLegalBean.setConsecutivo(resultSet.getString("Consecutivo"));
					firmaLegalBean.setObservacion(resultSet.getString("Observacion"));
					firmaLegalBean.setRecurso(resultSet.getString("Recurso"));
					return firmaLegalBean;
				}
			});
			return matches;
		}



		public ParametrosSisServicio getParametrosSisServicio() {
			return parametrosSisServicio;
		}

		public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
			this.parametrosSisServicio = parametrosSisServicio;
		}

}
