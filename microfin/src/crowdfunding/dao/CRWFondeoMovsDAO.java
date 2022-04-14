package crowdfunding.dao;

import crowdfunding.bean.CRWFondeoMovsBean;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import credito.bean.CreditosMovsBean;
import general.dao.BaseDAO;
import herramientas.Constantes;

public class CRWFondeoMovsDAO extends BaseDAO {

	public CRWFondeoMovsDAO(){
		super();
	}

	public List listaGrid(int tipoLista, CRWFondeoMovsBean crwFondeoMovs){

		String query = "call FONDEOKUBOMOVSLIS(?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = {
					crwFondeoMovs.getSolFondeoID(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO


					};
		List matches=jdbcTemplate.query(query, parametros ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CRWFondeoMovsBean crwFondeoMovs = new CRWFondeoMovsBean();
				crwFondeoMovs.setAmortizacionID(resultSet.getString(1));
				crwFondeoMovs.setFechaOperacion(resultSet.getString(2));
				crwFondeoMovs.setDescripcion(resultSet.getString(3));
				crwFondeoMovs.setTipoMovKuboID(resultSet.getString(4));
				crwFondeoMovs.setNatMovimiento(resultSet.getString(5));
				crwFondeoMovs.setCantidad(String.valueOf(resultSet.getDouble(6)));

				return crwFondeoMovs;
			}
		});

		return matches;

	}
}
