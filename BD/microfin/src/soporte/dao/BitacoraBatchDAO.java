package soporte.dao;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;

import soporte.bean.BitacoraBatchBean;


public class BitacoraBatchDAO extends BaseDAO {

	/**
	 * Consulta si un proceso batch ya se encuentra ejecutado en la bitacora.
	 * @param bitacoraBatchBean : Bean con los datos para realizar la consulta SP-BITACORABATCHCON.
	 * @param tipoConsulta : Número de Consulta 2.
	 * @return {@link BitacoraBatchBean} con el resultado de la consulta.
	 * @author avelasco
	 */
	public BitacoraBatchBean consultaEjecucion(final BitacoraBatchBean bitacoraBatchBean, final int tipoConsulta){
		BitacoraBatchBean bitacoraBean = null;
		try {
			bitacoraBean = (BitacoraBatchBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						//Query con el Store Procedure
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call BITACORABATCHCON("
												+ "?,?,?,?,?,		"
												+ "?,?,?,?,?,		"
												+ "?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_ProcesoBatchID",Utileria.convierteEntero(bitacoraBatchBean.getProcesoBatchID()));
							sentenciaStore.setString("Par_Fecha",bitacoraBatchBean.getFecha());
							sentenciaStore.setString("Par_FechaBatch",Constantes.FECHA_VACIA);
							sentenciaStore.setInt("Par_NumCon",tipoConsulta);
							sentenciaStore.setInt("Par_EmpresaID",Constantes.ENTERO_CERO);
							sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Aud_FechaActual", Constantes.FECHA_VACIA);

							sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
							sentenciaStore.setString("Aud_ProgramaID","BitacoraBatchDAO.consultaEjecucion");
							sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
							sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
						DataAccessException {
							BitacoraBatchBean bitacoraBean = new BitacoraBatchBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								bitacoraBean.setExisteEjecucion(resultadosStore.getString("ExisteEjecucion"));
								bitacoraBean.setFecha(resultadosStore.getString("Fecha"));
							}
							return bitacoraBean;
						}
					});
			return bitacoraBean;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta ejecución en bitacora batch: ", e);
			return null;
		}
	}
}