package pld.dao;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import pld.bean.NivelRiesgoPunBean;

public class NivelRiesgoPunDAO extends BaseDAO {

	public List<NivelRiesgoPunBean> listaReporte(NivelRiesgoPunBean bean,final int tipoLista) {
		List<NivelRiesgoPunBean> matches = null;
		try {
			String query = "call PLDNIVELRIESGOHISREP("
							+ "?,?,?,?,?,		"
							+ "?,?,?,?,?,		"
							+ "?,?,?,?);";
			Object[] parametros = {
					
					OperacionesFechas.conversionStrDate(bean.getFechaInicio()),
					OperacionesFechas.conversionStrDate(bean.getFechaFinal()),
					bean.getSucursalID(),
					bean.getClienteID(),
					bean.getTipoPersona(),
					
					bean.getTipoProceso(),
					tipoLista,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"NivelRiesgoPunDAO.listaReporte",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call PLDNIVELRIESGOHISREP(" + Arrays.toString(parametros) + ")");
			matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					NivelRiesgoPunBean lista = new NivelRiesgoPunBean();

					lista.setFecha(resultSet.getString("Fecha"));
					lista.setHora(resultSet.getString("Hora"));
					lista.setClienteID(resultSet.getString("ClienteID"));
					lista.setNombreCompleto(resultSet.getString("NombreCompleto"));
					lista.setSucursalOrigen(resultSet.getString("SucursalOrigen"));
					lista.setNombreSucurs(resultSet.getString("NombreSucurs"));
					lista.setPorc1TotalAntec(resultSet.getString("Porc1TotalAntec"));
					lista.setPorc2Localidad(resultSet.getString("Porc2Localidad"));
					lista.setPorc3ActividadEc(resultSet.getString("Porc3ActividadEc"));
					lista.setPorc4TotalOriRe(resultSet.getString("Porc4TotalOriRe"));
					lista.setPorc5TotalDesRe(resultSet.getString("Porc5TotalDesRe"));
					lista.setPorc6TotalPerf(resultSet.getString("Porc6TotalPerf"));
					lista.setPorc1TotalEBR(resultSet.getString("Porc1TotalEBR"));
					lista.setTotalPonderado(resultSet.getString("TotalPonderado"));
					lista.setNivelRiesgoObt(resultSet.getString("NivelRiesgoObt"));
					lista.setTipoProceso(resultSet.getString("TipoProceso"));
					return lista;
				}
			});
		} catch (Exception ex) {
			ex.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en lista Reporte de PLD", ex);
		}
		return matches;
	}

}
