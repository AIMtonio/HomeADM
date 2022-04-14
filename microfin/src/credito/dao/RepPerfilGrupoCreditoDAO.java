package credito.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
 
import org.springframework.jdbc.core.RowMapper;

import credito.bean.RepPerfilGrupoCreditoBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class RepPerfilGrupoCreditoDAO extends BaseDAO{
	
	public RepPerfilGrupoCreditoDAO (){
		super();
	}
	public RepPerfilGrupoCreditoBean ConsultaPerfilGrupo(
			RepPerfilGrupoCreditoBean repPerfilGrupoCreditoBean, int con_PerfilGpo) {
		String query = "call GRUPOSCREDITOCON(" +
				"?,?,?,?,?, ?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(repPerfilGrupoCreditoBean.getGrupoID()),
				Utileria.convierteEntero(repPerfilGrupoCreditoBean.getCicloActual()),
				con_PerfilGpo,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"RepPerfilGrupoCreditoDAO.ConsultaPerfilGrupo",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call GRUPOSCREDITOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				RepPerfilGrupoCreditoBean repPerfilGrupoBean = new RepPerfilGrupoCreditoBean();

				repPerfilGrupoBean.setSucursalID(resultSet.getString(5));
				repPerfilGrupoBean.setNombreSucur(resultSet.getString(6));
				repPerfilGrupoBean.setFechaUltCiclo(resultSet.getString(8));
				repPerfilGrupoBean.setNombrePromotor(resultSet.getString(10));
				repPerfilGrupoBean.setDireccionCompleta(resultSet.getString(11));

				return repPerfilGrupoBean;

			}
		});
		return matches.size() > 0 ? (RepPerfilGrupoCreditoBean) matches.get(0) : null;
	}

}
