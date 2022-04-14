package pld.dao;

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

import pld.bean.PLDListaNegrasBean;
import pld.bean.SeguimientoPersonaListaBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class SeguimientoPersonaListaDAO extends BaseDAO {

	public SeguimientoPersonaListaDAO() {
		super();
	}


	/**
	 * Método para modificar el seguimiento de personas en listas
	 * @param seguimientoPersonaListaBean: Bean con la información de la persona a dar de alta en las listas negras PLD
	 * @return
	 */
	public MensajeTransaccionBean modificacion(final SeguimientoPersonaListaBean seguimientoPersonaListaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call PLDSEGPERSONALISTASMOD("
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?,     "
											+ "?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_OpeInusualID", seguimientoPersonaListaBean.getOpeInusualID());
									sentenciaStore.setString("Par_PermiteOperacion", seguimientoPersonaListaBean.getPermiteOperacion());
									sentenciaStore.setString("Par_Comentario", seguimientoPersonaListaBean.getComentario());

									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());

									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", "SeguimientoPersonasListas");
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());

									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());

									return sentenciaStore;
								}
							}, new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
										DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if (callableStatement.execute()) {
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}
									return mensajeTransaccion;
								}
							}
							);

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en modificar Seguimiento de personas en listas", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}



	/**
	 * Consulta de personas en listas negras
	 * @param seguimientoPersonaListaBean: Bean con el ID para la consulta de el seguimiento
	 * @param tipoConsulta: Numero de consulta
	 * @return
	 */
	public SeguimientoPersonaListaBean consultaPrincipal(final SeguimientoPersonaListaBean seguimientoPersonaListaBean, int tipoConsulta) {
		String query = "call PLDSEGPERSONALISTASCON(?,?,?,?,?,	?,?,?,?,?, ?,?);";
		Object[] parametros = {

				seguimientoPersonaListaBean.getOpeInusualID(),
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,
				Constantes.STRING_VACIO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"SeguimientoPersonaListaDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO

		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call PLDSEGPERSONALISTASCON(" + Arrays.toString(parametros) + ")");
		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SeguimientoPersonaListaBean seguimientoPersona = new SeguimientoPersonaListaBean();

				seguimientoPersona.setOpeInusualID(resultSet.getString("OpeInusualID"));
				seguimientoPersona.setTipoPersona(resultSet.getString("TipoPersonaSAFI"));
				seguimientoPersona.setNumRegistro(Utileria.completaCerosIzquierda(resultSet.getString("ClavePersonaInv"),10));
				seguimientoPersona.setNombre(resultSet.getString("Nombre"));
				seguimientoPersona.setFechaDeteccion(resultSet.getString("FechaDeteccion"));
				seguimientoPersona.setListaDeteccion(resultSet.getString("TipoDeteccion"));
				seguimientoPersona.setNombreDet(resultSet.getString("NombreDet"));
				seguimientoPersona.setApellidoDet(resultSet.getString("ApellidoDet"));
				seguimientoPersona.setFechaNacimientoDet(resultSet.getString("FechaNacimientoDet"));
				seguimientoPersona.setRfcDet(resultSet.getString("RFCDet"));
				seguimientoPersona.setPaisDetID(resultSet.getString("PaisDetID"));
				seguimientoPersona.setPermiteOperacion(resultSet.getString("PermiteOperacion"));
				seguimientoPersona.setComentario(resultSet.getString("Comentario"));
				seguimientoPersona.setListaID(resultSet.getString("ListaID"));
				seguimientoPersona.setTipoLista(resultSet.getString("TipoLista"));
				seguimientoPersona.setNombreCompleto(resultSet.getString("NombreCompleto"));
				seguimientoPersona.setFechaNacimientoCon(resultSet.getString("FechaNacimiento"));
				seguimientoPersona.setPaisConID(resultSet.getString("PaisID"));
				seguimientoPersona.setEstadoConID(resultSet.getString("EstadoID"));
				seguimientoPersona.setRazonSocial(resultSet.getString("RazonSocial"));
				seguimientoPersona.setRfcCon(resultSet.getString("RFC"));

				return seguimientoPersona;
			}
		});
		return matches.size() > 0 ? (SeguimientoPersonaListaBean) matches.get(0) : null;
	}


	/**
	 * Consulta de personas en listas negras
	 * @param seguimientoPersonaListaBean: Bean con el ID para la consulta de el seguimiento
	 * @param tipoConsulta: Numero de consulta
	 * @return
	 */
	public SeguimientoPersonaListaBean consultaPermite(final SeguimientoPersonaListaBean seguimientoPersonaListaBean, int tipoConsulta) {
		String query = "call PLDSEGPERSONALISTASCON(?,?,?,?,?,	?,?,?,?,?, ?,?);";
		Object[] parametros = {

				Constantes.ENTERO_CERO,
				seguimientoPersonaListaBean.getNumRegistro(),
				seguimientoPersonaListaBean.getTipoLista(),
				seguimientoPersonaListaBean.getListaDeteccion(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"SeguimientoPersonaListaDAO.consultaPermite",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO

		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call PLDSEGPERSONALISTASCON(" + Arrays.toString(parametros) + ")");
		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SeguimientoPersonaListaBean seguimientoPersona = new SeguimientoPersonaListaBean();

				seguimientoPersona.setOpeInusualID(resultSet.getString("OpeInusualID"));
				seguimientoPersona.setNumRegistro(Utileria.completaCerosIzquierda(resultSet.getString("NumRegistro"),10));
				seguimientoPersona.setFechaDeteccion(resultSet.getString("FechaDeteccion"));
				seguimientoPersona.setPermiteOperacion(resultSet.getString("PermiteOperacion"));


				return seguimientoPersona;
			}
		});
		return matches.size() > 0 ? (SeguimientoPersonaListaBean) matches.get(0) : null;
	}


	/**
	 * Lista principal para personas en listas negras
	 * @param tipoLista: Numero de lista
	 * @param pldListaNegrasBean: Bean con el primer nombre para filtrar la lista
	 * @return
	 */
	public List listaPrincipal(final SeguimientoPersonaListaBean seguimientoPersonaListaBean, int tipoLista) {
		List listaPrincipal = null;
		try {
			String query = "call PLDSEGPERSONALISTASLIS(?,?,?,?,?, ?,?,?,?);";
			Object[] parametros = {
					seguimientoPersonaListaBean.getNombre(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"SeguimientoPersonaListaDAO.listaPrincipal",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()

			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call PLDSEGPERSONALISTASLIS(" + Arrays.toString(parametros) + ")");
			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					SeguimientoPersonaListaBean seguimientoPersona = new SeguimientoPersonaListaBean();
					seguimientoPersona.setOpeInusualID(resultSet.getString("OpeInusualID"));
					seguimientoPersona.setNombre(resultSet.getString("Nombre"));

					return seguimientoPersona;
				}
			});
			listaPrincipal = matches;

		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en lista principal de lista de seguiminto de personas en lista", e);
		}
		return listaPrincipal;

	}

}
