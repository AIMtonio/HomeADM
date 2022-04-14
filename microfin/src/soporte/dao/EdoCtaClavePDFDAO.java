package soporte.dao;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

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


import soporte.bean.EdoCtaClavePDFBean;

public class EdoCtaClavePDFDAO extends BaseDAO {
	EdoCtaParamsDAO edoCtaParamsDAO = null;

	public EdoCtaClavePDFBean consultaPrincipalClavePDF(final EdoCtaClavePDFBean edoCtaClavePDFBean, int tipoConsulta){
		List matches = null;
		try {
			String query = "call EDOCTACLAVEPDFCON (?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteEntero(edoCtaClavePDFBean.getClienteID()),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"EdoCtaClavePDFDAO.consultaPrincipalClavePDF",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};

			//Logueamos la sentencia
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOCTACLAVEPDFCON (" + Arrays.toString(parametros) + ")");
			matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EdoCtaClavePDFBean edoCtaClavePDFBean = new EdoCtaClavePDFBean();
					edoCtaClavePDFBean.setClienteID(resultSet.getString("ClienteID"));
					edoCtaClavePDFBean.setContrasenia(resultSet.getString("Contrasenia"));
					edoCtaClavePDFBean.setCorreoEnvio(resultSet.getString("CorreoEnvio"));
					edoCtaClavePDFBean.setFechaActualiza(resultSet.getString("FechaActualiza"));
					edoCtaClavePDFBean.setClavePDF(resultSet.getString("ClavePDF"));
					return edoCtaClavePDFBean;
				}
			});
		}
		catch(Exception e) {
			loggerSAFI.error("Error al consultar el usuario:" + e.getMessage());
			loggerSAFI.error(e);
			matches = new ArrayList();
		}


		return matches.size() > 0 ? (EdoCtaClavePDFBean) matches.get(0) : null;
	}

	public MensajeTransaccionBean actualizaContraseniaClavePDF(final int numeroActualizacion, final EdoCtaClavePDFBean edoCtaClavePDFBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL EDOCTACLAVEPDFPRO(?,?,  ?,?,?,  ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(edoCtaClavePDFBean.getClienteID()));
									sentenciaStore.setString("Par_Contrasenia", edoCtaClavePDFBean.getContrasenia());

									//Parametros de salida
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .EdoCtaClavePDFDAO.actualizaClavePDF");
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
						throw new Exception(Constantes.MSG_ERROR + " .EdoCtaClavePDFDAO.actualizaClavePDF");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al actualizar los datos de la clave del PDF" + e);
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



	public EdoCtaParamsDAO getEdoCtaParamsDAO() {
		return edoCtaParamsDAO;
	}

	public void setEdoCtaParamsDAO(EdoCtaParamsDAO edoCtaParamsDAO) {
		this.edoCtaParamsDAO = edoCtaParamsDAO;
	}
}
