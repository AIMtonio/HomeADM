package pld.dao;

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
import java.util.StringTokenizer;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import pld.bean.NivelesRiesgoBean;

public class NivelesRiesgoDAO extends BaseDAO {

	public NivelesRiesgoDAO(){
		super();
	}

	public MensajeTransaccionBean actualizaNivelRiesgo(final NivelesRiesgoBean nivelesRiesgoBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(
												parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					// Array de niveles riesgo pld
					ArrayList nivelesRiesgoPLD=(ArrayList) creaListaNivelesPLD(nivelesRiesgoBean);

					if(!nivelesRiesgoPLD.isEmpty()){
						for(int i=0;i<nivelesRiesgoPLD.size();i++){
							final NivelesRiesgoBean nivelRiesgoBean=(NivelesRiesgoBean)nivelesRiesgoPLD.get(i);
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(
														parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CATNIVELESRIESGOACT  (?,?,?,?,?,"
																		+ "?,?,?,?,?,"
																		+ "?,?,?,?,?,"
																		+ "?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_NivelRiesgoID",nivelRiesgoBean.getNivelRiesgoID());
								sentenciaStore.setString("Par_TipoPersona",nivelRiesgoBean.getTipoPersona());
								sentenciaStore.setInt("Par_Minimo",	Utileria.convierteEntero(nivelRiesgoBean.getMinimo()));
								sentenciaStore.setInt("Par_Maximo",	Utileria.convierteEntero(nivelRiesgoBean.getMaximo()));
								sentenciaStore.setString("Par_SeEscala",nivelRiesgoBean.getSeEscala());
								sentenciaStore.setString("Par_Estatus",nivelRiesgoBean.getEstatus());

								sentenciaStore.setString("Par_Salida",Constantes.STRING_SI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());

								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", "NivelesRiesgoDAO.actualizaNivelRiesgo" );
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
									mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						});
						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}

						}//fin del for
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(0);
						mensajeBean.setDescripcion("Catálogo de Niveles de  Riesgo Actualizado Exitosamente.");
						mensajeBean.setNombreControl("nivelRiesgoID");

					}else{
						mensajeBean =new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("La Lista de Niveles de Riesgo Está Vacia.");
						throw new Exception(mensajeBean.getDescripcion());
					}

				}catch(Exception e){
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizacion catalogo niveles riesgo", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Metodo que arma los beans a partir de una lista
	private List creaListaNivelesPLD(NivelesRiesgoBean nivelesBean){
		StringTokenizer tokensBean = new StringTokenizer(nivelesBean.getListaNivelesPLD(), "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaBeanNiveles = new ArrayList();
		NivelesRiesgoBean nivelBean;

		while (tokensBean.hasMoreTokens()) {
			nivelBean = new NivelesRiesgoBean();

			stringCampos = tokensBean.nextToken();
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");

			nivelBean.setNivelRiesgoID(tokensCampos[0]);
			nivelBean.setMinimo(tokensCampos[1]);
			nivelBean.setMaximo(tokensCampos[2]);
			nivelBean.setSeEscala(tokensCampos[3]);
			nivelBean.setEstatus(tokensCampos[4]);
			nivelBean.setTipoPersona(tokensCampos[5]);

			listaBeanNiveles.add(nivelBean);

		}
		return listaBeanNiveles;
	}

	public List consultaPrincipal(NivelesRiesgoBean nivelRiesgo) {
		try {
			// Query con el Store Procedure
			String query = "call CATNIVELESRIESGOCON("
					+ "?,?,?,?,?,		"
					+ "?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(nivelRiesgo.getTipoConsulta()),
					nivelRiesgo.getTipoPersona(),
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CatalogoNivelesRiesgo.consultaPrincipal",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call CATNIVELESRIESGOCON(" + Arrays.toString(parametros) + ")");

			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					NivelesRiesgoBean nivelRiesgoBean = new NivelesRiesgoBean();
					nivelRiesgoBean.setNivelRiesgoID(resultSet.getString("NivelRiesgoID"));
					nivelRiesgoBean.setDescripcion(resultSet.getString("Descripcion"));
					nivelRiesgoBean.setMinimo(resultSet.getString("Minimo"));
					nivelRiesgoBean.setMaximo(resultSet.getString("Maximo"));
					nivelRiesgoBean.setSeEscala(resultSet.getString("SeEscala"));
					nivelRiesgoBean.setEstatus(resultSet.getString("Estatus"));
					nivelRiesgoBean.setTipoPersona(resultSet.getString("TipoPersona"));
					return nivelRiesgoBean;
				}
			});
			return matches;
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return null;
	}

}
