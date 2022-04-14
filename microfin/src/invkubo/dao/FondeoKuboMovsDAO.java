package invkubo.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import invkubo.bean.FondeoKuboMovsBean;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import credito.bean.CreditosMovsBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
 
public class FondeoKuboMovsDAO extends BaseDAO {
	
	public FondeoKuboMovsDAO(){
		super();
	}
	
	public List listaGrid(int tipoLista, FondeoKuboMovsBean fondeoKuboMovs){
		
		String query = "call FONDEOKUBOMOVSLIS(?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = {
					fondeoKuboMovs.getFondeoKuboID(),
					tipoLista,
					
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FONDEOKUBOMOVSLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				FondeoKuboMovsBean fondeoKuboMovs = new FondeoKuboMovsBean();
				fondeoKuboMovs.setAmortizacionID(resultSet.getString(1));
				fondeoKuboMovs.setFechaOperacion(resultSet.getString(2)); 
				fondeoKuboMovs.setDescripcion(resultSet.getString(3));
				fondeoKuboMovs.setTipoMovKuboID(resultSet.getString(4));
				fondeoKuboMovs.setNatMovimiento(resultSet.getString(5));
				fondeoKuboMovs.setCantidad(String.valueOf(resultSet.getDouble(6)));

				return fondeoKuboMovs;
			}
		});
	
		return matches;	
				
	}
}
