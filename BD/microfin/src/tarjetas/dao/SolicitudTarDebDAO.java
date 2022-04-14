package tarjetas.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import cliente.bean.ClienteBean;
import cliente.bean.MunicipiosRepubBean;

import tarjetas.bean.SolicitudTarDebBean;
import tarjetas.bean.TarjetaDebitoBean;


import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class SolicitudTarDebDAO  extends BaseDAO{
	public SolicitudTarDebDAO() {
		super();
	}
	public MensajeTransaccionBean solicitud(final int tipoTransaccion,final SolicitudTarDebBean solicitudTarDebBean) {
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
									String query = "call TARDEBSOLICALT(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,? ,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);


									sentenciaStore.setInt("Par_TipoTransaccion",tipoTransaccion);
									sentenciaStore.setInt("Par_CorpRelacionadoID",Utileria.convierteEntero(solicitudTarDebBean.getCorpRelacionadoID()));
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(solicitudTarDebBean.getClienteID()));
									sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(solicitudTarDebBean.getCuentaAhoID()));
									sentenciaStore.setInt("Par_TipoTarjetaID",Utileria.convierteEntero(solicitudTarDebBean.getTarjetaTipo()));
									sentenciaStore.setString("Par_NombreTarjeta",solicitudTarDebBean.getNombreTarjeta());
									sentenciaStore.setString("Par_Relacion",solicitudTarDebBean.getRelacion());
									sentenciaStore.setDouble("Par_Costo",Utileria.convierteDoble(solicitudTarDebBean.getCosto()));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Proceso de Solicitud de Tarjeta de Débito", e);
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

	// Cancelacion de solicitudes

	public MensajeTransaccionBean solicitudCancela(final int tipoTransaccion,final SolicitudTarDebBean solicitudTarDebBean) {
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
									String query = "call TARDEBSOLICBAJ(?,?,?,?,?,  ?,?,?,?,?,  ?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);


									sentenciaStore.setInt("Par_FolioSolicitudID",Utileria.convierteEntero(solicitudTarDebBean.getFolio()));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Proceso de Cancelacion de Solicitud de Tarjeta ", e);
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


	/* Lista de Folios de Tarjetas */
	public List listaFolioTarjetas(SolicitudTarDebBean solicitudTarDebBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call SOLICITUDTARDEBLIS(?,?,?, ?,?,? ,?,?,?);";
		Object[] parametros = {
								solicitudTarDebBean.getFolio(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICITUDTARDEBLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SolicitudTarDebBean folios = new SolicitudTarDebBean();
				folios.setFolio(resultSet.getString(1));
				folios.setNombreCompleto(resultSet.getString(2));
				return folios;
			}
		});
		return matches;
	}

	public SolicitudTarDebBean consultaSolNominativa(final int tipoConsulta, SolicitudTarDebBean solicitudTarDebBean) {
		//Query con el Store Procedure
		String query = "call SOLICITUDTARDEBCON(?,?,?,?,?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {	solicitudTarDebBean.getFolio(),
								solicitudTarDebBean.getClienteID(),
								solicitudTarDebBean.getCuentaAhoID(),
								solicitudTarDebBean.getRelacion(),
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"SolicitudTarDebDAO.consultaSolNominativa",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICITUDTARDEBCON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SolicitudTarDebBean solicitudBean = new SolicitudTarDebBean();
				solicitudBean.setEstatus(resultSet.getString(1));
				return solicitudBean;
			}
		});
		return matches.size() > 0 ? (SolicitudTarDebBean) matches.get(0) : null;

	}

	public SolicitudTarDebBean consulta(final int tipoConsulta, SolicitudTarDebBean solicitudTarDebBean) {
		//Query con el Store Procedure
		String query = "call SOLICITUDTARDEBCON(?,?,?,?,?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {	solicitudTarDebBean.getFolio(),
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.STRING_VACIO,
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"SolicitudTarDebDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICITUDTARDEBCON(" + Arrays.toString(parametros) + ")");


		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SolicitudTarDebBean folios = new SolicitudTarDebBean();

				folios.setCorpRelacionadoID(resultSet.getString(1));
				folios.setTarjetaDebAntID(resultSet.getString(2));
				folios.setClienteID(resultSet.getString(3));
				folios.setNombreCompleto(resultSet.getString(4));
				folios.setCuentaAhoID(resultSet.getString(5));
				folios.setTarjetaTipo(resultSet.getString(6));
				folios.setNombreTarjeta(resultSet.getString(7));
				folios.setCosto(resultSet.getString(8));
				folios.setEstatus(resultSet.getString(9));
				folios.setDescripcion(resultSet.getString(10));
				folios.setRelacion(resultSet.getString(11));

					return folios;

			}
		});
		return matches.size() > 0 ? (SolicitudTarDebBean) matches.get(0) : null;

	}



}
