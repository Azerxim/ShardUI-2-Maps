async function MarkersReligions(world) {
    const response = await fetch("api/get/religions.php?data="+world);
    const res = await response.json();
    const datas = res.posts;
    let polygons = [];
    let markers = [];
    let popup, tooltip, icon;
    // console.log(datas);
    for (const one in datas){
        let data = datas[one];
        // Polygons
        popup = '<a href="/rp/civilisation/'+data.civid+'" class="button is-TD-smoothwhite" style="height: 30px;">'+data.name+'</a>';
        tooltip = '';
        icon = 'udbIcon';
        for (let polygon in data.polygons.villes) {
            let subdata = data.polygons.villes[polygon];
            if (subdata.religion.id != 0) {
                popup = '<a href="/rp/civilisation/'+subdata.religion.id+'" class="button is-TD-smoothwhite" style="height: 30px;">'+subdata.religion.name+'</a>';
            }
            polygons.push({type: subdata.shape, dbid: subdata.cartoid, option: "civ", authorisation: data.authorisation, coords: subdata.coords, color: subdata.religion.color, text: subdata.text, icon: subdata.inactif ? yellowIcon : icon, popup: popup, tooltip: tooltip});
        }
        for (let polygon in data.polygons.quartiers) {
            let subdata = data.polygons.quartiers[polygon];
            if (subdata.religion.id != 0) {
                popup = '<a href="/rp/civilisation/'+subdata.religion.id+'" class="button is-TD-smoothwhite" style="height: 30px;">'+subdata.religion.name+'</a>';
            }
            polygons.push({type: subdata.shape, dbid: subdata.cartoid, option: "quartier", authorisation: data.authorisation, coords: subdata.coords, color: subdata.religion.color, text: subdata.text, icon: subdata.inactif ? yellowIcon : icon, popup: popup, tooltip: tooltip});
        }
        
        // Villes
        for (let ville in data.villes) {
            let subdata = data.villes[ville];
            popup = '<a href="/rp/ville/'+subdata.villeid+'" class="button is-TD-smoothwhite" style="height: 30px;">'+subdata.name+'</a>';
            tooltip = '<b class="ultradarkblue">'+subdata.name+'</b>';
            if (subdata.parc == '1') {
                if (subdata.capitale == '1') { icon = redIcon }
                else { icon = cyanIcon }
            }
            else {
                if (subdata.capitale == '1') { icon = CapitaleIcon }
                else { icon = CityIcon }
            }
            if (data.inactif == '1') { icon = yellowIcon }
            markers.push({type: 'Markers', option: "civ", authorisation: data.authorisation, coords: "["+parseInt(-1*subdata.coord_z)+","+parseInt(subdata.coord_x)+"]", icon: icon, popup: popup, tooltip: tooltip});
            
            // Quartiers
            let q_subdata;
            for (let quartier in subdata.quartiers) {
                q_subdata = subdata.quartiers[quartier];
                tooltip = '<b class="ultradarkblue">'+q_subdata.name+'</b>';
                if (q_subdata.parc == '1') { icon = greenIcon }
                else { icon = QuartierIcon }
                if (data.inactif == '1') { icon = yellowIcon }
                markers.push({type: 'Markers', option: "quartier", authorisation: data.authorisation, coords: "["+parseInt(-1*q_subdata.coord_z)+","+parseInt(q_subdata.coord_x)+"]", icon: icon, popup: popup, tooltip: tooltip});
            }
        }
    }
    const json = {polygons: polygons, markers: markers}
    return json
}