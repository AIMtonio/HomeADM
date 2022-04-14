package pld.dao;

import general.dao.BaseDAO;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import pld.bean.PersInvListasBean;

public class PersInvListasDAO extends BaseDAO{

	public List<PersInvListasBean> listaReporte(int tipoReporte, PersInvListasBean pers) {
		List<PersInvListasBean> ListaResultado = null;
		try {
			String query = "CALL PLDPERSINVLISTASREP(?,?,?,?,?," + "?,?,?,?);";
			Object[] parametros = {
					tipoReporte,
					pers.getSucursal(),
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "CALL PLDPERSINVLISTASREP(" + Arrays.toString(parametros) + ");");
			List<PersInvListasBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PersInvListasBean persona = new PersInvListasBean();
					persona.setClavePersonaInv(resultSet.getString("ClavePersonaInv"));
					persona.setNombreCompleto(resultSet.getString("NombreCompleto"));
					persona.setFechaAlta(resultSet.getString("FechaAlta"));
					persona.setFechaIniTran(resultSet.getString("FechaIniTran"));
					persona.setTipoLista(resultSet.getString("TipoLista"));
					persona.setNumeroOficio(resultSet.getString("NumeroOficio"));
					persona.setOrigenDeteccion(resultSet.getString("OrigenDeteccion"));
					return persona;
				}
			});
			ListaResultado = matches;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en reporte de personas involucradas: ", e);
		}
		return ListaResultado;
	}

}
