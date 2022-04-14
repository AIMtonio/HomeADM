package ventanilla.dao;

import ventanilla.bean.UsuarioServiciosBean;
import general.bean.MensajeTransaccionArchivoBean;
import general.dao.BaseDAO;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import herramientas.Constantes;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import cliente.bean.ClienteArchivosBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Utileria;


public class UsuarioArchivosDAO extends BaseDAO{

	public UsuarioArchivosDAO() {
		// TODO Auto-generated constructor stub
	}


	/* Alta de de un archivo digital, en este metodo se envia un valor para el campo Instrumento de la tabla */
	public MensajeTransaccionArchivoBean altaArchivo(final UsuarioServiciosBean archivo) {
		MensajeTransaccionArchivoBean mensaje = new MensajeTransaccionArchivoBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionArchivoBean)transactionTemplate.execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionArchivoBean mensajeBean = new MensajeTransaccionArchivoBean();
				try {
					mensajeBean = (MensajeTransaccionArchivoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {


							String query = "call USUARIOSERARCHIVOALT(?,?,?,?,?, ?,?,?,?,?," +
																	 "?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setString("Par_UsuarioID",archivo.getUsuarioID());
							sentenciaStore.setString("Par_TipoDocumen",archivo.getTipoDocumento());

							sentenciaStore.setString("Par_Observacion", archivo.getObservacion());
							sentenciaStore.setString("Par_Recurso",archivo.getRecurso());
							sentenciaStore.setString("Par_Extension",archivo.getExtension());

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
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" Error en alta de archivos: " + e);

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
	} // fin de alta archivo cliente


	public MensajeTransaccionArchivoBean bajaArchivos(final UsuarioServiciosBean archivo) {
		MensajeTransaccionArchivoBean mensaje = new MensajeTransaccionArchivoBean();
			mensaje = (MensajeTransaccionArchivoBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
			new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionArchivoBean mensajeBean = new MensajeTransaccionArchivoBean();
				try {
					mensajeBean = (MensajeTransaccionArchivoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call USUARIOSERARCHIVOBAJ(?,?,?,?,?,	?,?,?,?,?,	?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_UsuarioSerArchiID",Utileria.convierteEntero(archivo.getUsuarioArchivoID()));
							sentenciaStore.setInt("Par_UsuarioID",Utileria.convierteEntero(archivo.getUsuarioID()));
							sentenciaStore.setString("Par_TipoDocumen",archivo.getTipoDocumento());

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID",Constantes.ENTERO_CERO);
							sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Aud_FechaActual", Constantes.FECHA_VACIA);
							sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
							sentenciaStore.setString("Aud_ProgramaID","ClienteArchivosDAO");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en baja de archivos" + e);
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

	/* Lista de Archivos por Cliente*/
	public List listaArchivosUsuario(UsuarioServiciosBean archivoBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call USUARIOSERARCHIVOLIS(?,?,?,?,?,	?,?,?,?,?,	?);";
		Object[] parametros = {
				Utileria.convierteEntero(archivoBean.getUsuarioID()),
				archivoBean.getTipoDocumento(),
				Constantes.ENTERO_CERO,
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"listaArchivosCliente",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSERARCHIVOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UsuarioServiciosBean archivoBean = new UsuarioServiciosBean();
				archivoBean.setObservacion(resultSet.getString("Observacion"));
				archivoBean.setRecurso(resultSet.getString("Recurso"));
				archivoBean.setTipoDocumento(resultSet.getString("TipoDocumento"));
				archivoBean.setConsecutivo(resultSet.getString("Consecutivo"));
				archivoBean.setUsuarioArchivoID(resultSet.getString("UsuarioSerArchiID"));
				archivoBean.setFechaRegistro(resultSet.getString("FechaRegistro"));
				return archivoBean;
			}
		});
		return matches;
	}


}
