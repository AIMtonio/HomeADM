package fondeador.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import fondeador.bean.CondicionesDesctoEdoLinFonBean;
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
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

public class CondicionesDesctoEdoLinFonDAO extends BaseDAO{

	public CondicionesDesctoEdoLinFonDAO() {
		super();
	}

	// ------------------ Transacciones ------------------------------------------

	/* Alta de condiciones de descuento para estados, municipios, localidades */
	public MensajeTransaccionBean alta(final CondicionesDesctoEdoLinFonBean condicionesDesctoEdoLinFonBean, final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call LINFONCONDEDOALT(" +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_LineaFondeoID",Utileria.convierteEntero(condicionesDesctoEdoLinFonBean.getLineaFondeoIDEdo()));
								sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(condicionesDesctoEdoLinFonBean.getEstadoID()));
								sentenciaStore.setInt("Par_MunicipioID",Utileria.convierteEntero(condicionesDesctoEdoLinFonBean.getMunicipioID()));
								sentenciaStore.setInt("Par_LocalidadID",Utileria.convierteEntero(condicionesDesctoEdoLinFonBean.getLocalidadID()));
								sentenciaStore.setInt("Par_NumHabitantesInf",Utileria.convierteEntero(condicionesDesctoEdoLinFonBean.getNumHabitantesInf()));
								sentenciaStore.setInt("Par_NumHabitantesSup",Utileria.convierteEntero(condicionesDesctoEdoLinFonBean.getNumHabitantesSup()));
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								//Parametros de OutPut
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								//Parametros de Auditoria
								sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);
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
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " CondicionesDesctoEdoLinFonDAO.alta");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								}
								return mensajeTransaccion;
							}
						});
						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " CondicionesDesctoEdoLinFonDAO.alta");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Condiciones de linea de Fondeo" + e);
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

	/* Baja de condiciones de descuento para estados, municipios, localidades */
	public MensajeTransaccionBean baja(final CondicionesDesctoEdoLinFonBean condicionesDesctoEdoLinFonBean, final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call LINFONCONDEDOBAJ(" +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_LineaFondeoID",Utileria.convierteEntero(condicionesDesctoEdoLinFonBean.getLineaFondeoIDEdo()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								//Parametros de OutPut
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								//Parametros de Auditoria
								sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);
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
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " CondicionesDesctoEdoLinFonDAO.baja");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								}
								return mensajeTransaccion;
							}
						});
						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " CondicionesDesctoEdoLinFonDAO.baja");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Baja de Condiciones de linea de Fondeo" + e);
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

	/* Alta de las condiciones de descuento para estados, municipios, localidades de credito grid*/
	public MensajeTransaccionBean altaEstados(final CondicionesDesctoEdoLinFonBean condicionesDesctoEdoLinFonBean, final ArrayList listaEstados) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean=baja(condicionesDesctoEdoLinFonBean,parametrosAuditoriaBean.getNumeroTransaccion());
					if(mensajeBean.getNumero()!=0){
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}

					CondicionesDesctoEdoLinFonBean condicionesDesctoEdo = new CondicionesDesctoEdoLinFonBean();
					if(!listaEstados.isEmpty()){
						for(int i=0; i < listaEstados.size(); i++){
							condicionesDesctoEdo = (CondicionesDesctoEdoLinFonBean) listaEstados.get(i);
							if(condicionesDesctoEdo.getEstadoID().isEmpty()){
								throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}else{
								mensajeBean=alta(condicionesDesctoEdo,parametrosAuditoriaBean.getNumeroTransaccion());
								if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
						}
					}else{
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("Especificar Estados, Municipios, localidades ");
						mensajeBean.setNombreControl(Constantes.STRING_VACIO);
						mensajeBean.setConsecutivoString(Constantes.STRING_CERO);
						throw new Exception("Especificar Estados, Municipios, localidades ");
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Condiciones de linea de Fondeo" + e);
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

	/* Lista de Condiciones de desembolso de Linea Fondeador */
	public List listaPrincipal(CondicionesDesctoEdoLinFonBean lineaFond, int tipoLista) {
		//Query con el Store Procedure
		String query = "call LINFONCONDEDOLIS(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				lineaFond.getLineaFondeoIDEdo(),
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"LineaFondeadorDAO.listaPrincipal",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call LINEAFONDEADORLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CondicionesDesctoEdoLinFonBean condicionesDesctoEdoLinFonBean = new CondicionesDesctoEdoLinFonBean();
				condicionesDesctoEdoLinFonBean.setLineaFondeoIDEdo(String.valueOf(resultSet.getInt("LineaFondeoID")));
				condicionesDesctoEdoLinFonBean.setEstadoID(String.valueOf(resultSet.getInt("EstadoID")));
				condicionesDesctoEdoLinFonBean.setMunicipioID(String.valueOf(resultSet.getInt("MunicipioID")));
				condicionesDesctoEdoLinFonBean.setLocalidadID(String.valueOf(resultSet.getInt("LocalidadID")));
				condicionesDesctoEdoLinFonBean.setNumHabitantesInf(String.valueOf(resultSet.getInt("NumHabitantesInf")));
				condicionesDesctoEdoLinFonBean.setNumHabitantesSup(String.valueOf(resultSet.getInt("NumHabitantesSup")));
				return condicionesDesctoEdoLinFonBean;
			}
		});
		return matches;
	}

}

