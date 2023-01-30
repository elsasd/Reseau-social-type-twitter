<template>
  <b-container id="MainPage">
    <b-row id="nav-header">
      <b-col><h2>Caqueter</h2></b-col>
      <b-col v-if="logged">
        <b-link class="deco" v-on:click="logout">Deconnexion</b-link>
      </b-col>
      <b-col cols="4" v-if="!logged">
        <b-form
          style="padding-bottom: 20px"
          v-on:submit.prevent="login()"
          inline
        >
          <b-input-group
            prepend="@"
            class="mb-2 mr-sm-2 mb-sm-0"
            aria-label="pseudo"
          >
            <b-form-input
              v-model="user"
              id="inline-form-input-pseudo"
              placeholder="Pseudo"
            ></b-form-input>
            <b-button type="submit" variant="secondary">Connexion</b-button>
          </b-input-group>
        </b-form>
      </b-col>
    </b-row>
    <b-row id="maincontainer">
      <b-col cols="4" id="usettingssort">
        <br />
        <div id="loggedinfos">
          <h2
            v-if="logged"
            style="text-align: center; border-bottom: 1px solid lightgrey"
          >
            <img
              id="userpfp"
              ref="userpfp"
              :src="
                `${publicPath}pictures/` + this.$session.get('id_user') + '.png'
              "
              @error="setDefaultImg"
            />
            <br />
            {{ this.$session.get("user").toUpperCase() }}
          </h2>
        </div>
        <div v-if="logged" id="follows" style="text-align: center">
          {{ followings }} <span v-if="followings > 1">abonnements</span>
          <span v-else> abonnement </span>
          {{ followers }}
          <span v-if="followers > 1"> abonné.e.s </span>
          <span v-else> abonné.e </span>
        </div>
        <form v-if="logged" id="changepp" v-on:submit="changePfp()">
          <b-form-file
            v-model="newpfp"
            v-on:change="document.getElementById('changepp').submit()"
            class="form-control-file"
            id="newPP"
          />
          <button id="sendPP" type="submit">Envoyer</button>
        </form>
        <br />
        <div id="sorts">
          <b-row id="sort"> Afficher : </b-row>
          <b-row>
            <span
              ><input
                type="checkbox"
                v-model="all"
                @change="showAll()"
                id="sortall"
              />
              Tout</span
            >
          </b-row>
          <b-row>
            <span
              ><input
                type="checkbox"
                v-model="everyone"
                checked
                id="sorteveryone"
                @change="showEveryone()"
              />
              Les caques mentionnant
              <a> @everyone</a></span
            >
          </b-row>
          <b-row>
            <span v-if="logged"
              ><input
                type="checkbox"
                @change="showMe()"
                v-model="me"
                id="sortme"
              />
              Les caques qui me mentionnent</span
            >
          </b-row>
          <b-row>
            <span v-if="logged"
              ><input
                type="checkbox"
                @change="showFollowings()"
                v-model="foll"
                id="sortfollowing"
              />
              Les caques de mes abonnements</span
            >
          </b-row>
          <br />
          <b-row>
            <span>
              <b-input-group prepend="@" aria-label="recherche par utilisateur"
                ><b-form-input
                  @input="searchUser(rechercheuser)"
                  v-model="rechercheuser"
                  type="search"
                  placeholder="Chercher les caques de ..."
                  id="sortuser" /></b-input-group
            ></span>
          </b-row>
        </div>
        <br />
        <b-row>
          <span
            ><b-input-group prepend="#" aria-label="recherche par hashtag"
              ><b-form-input
                @input="searchTag(recherchetag)"
                v-model="recherchetag"
                type="search"
                prepend="#"
                id="sorttag"
                placeholder="Chercher la dernière tendance" /></b-input-group
          ></span>
        </b-row>
      </b-col>
      <b-col cols="8" id="maincolumn">
        <div id="ajoutcaque" v-if="logged">
          <br />
          <b-col sm="7">
            <b-form v-on:submit.prevent="addCaque()" inline>
              <b-input-group
                class="mb-2 mr-sm-2 mb-sm-0"
                aria-label="ajout caque"
              >
                <b-form-textarea
                  id="caquer"
                  placeholder="Caque m'en une !"
                  rows="2"
                  max-rows="5"
                  v-model="ajout"
                />
                <b-button type="submit" variant="secondary">Caquer</b-button>
              </b-input-group>
            </b-form>
          </b-col>
        </div>
        <br />
        <publication
          v-show="caque.visible"
          v-for="caque in caques"
          :message="caque.caque"
          :user="caque.user"
          :key="caque.id_caque"
          :ronrons="caque.ronrons"
          :date_pub="getDate(caque.date_pub)"
          :heure_pub="getHours(caque.date_pub)"
        >
          <template v-slot:pp
            ><img
              @click="(rechercheuser = caque.user), searchUser(caque.user)"
              class="pfp"
              :src="`${publicPath}pictures/` + caque.id_user + '.png'"
              @error="setDefaultImg"
            />
          </template>
          <template v-slot:username>
            <a
              class="caquser"
              @click="(rechercheuser = caque.user), searchUser(caque.user)"
              >{{ caque.user }}</a
            >
          </template>
          <template
            v-if="logged && caque.id_user != $session.get('id_user')"
            v-slot:follow
          >
            <input
              :disabled="!logged"
              v-model="caque.following"
              type="checkbox"
              @change="sendFollow(caque)"
              :id="`caque-follow` + caque.id_caque"
              class="btn-check"
              button
            />
            <label
              class="btn btn-outline-secondary"
              :for="`caque-follow` + caque.id_caque"
            >
              <img height="30" width="60" src="follow.png"
            /></label>
          </template>
          <template v-if="logged" v-slot:repondre>
            <button
              class="rep"
              style="text-align: left"
              @click="(ajout = '@' + caque.user + ' ' + ajout), addFocus()"
            >
              Répondre
            </button>
          </template>
          <template v-slot:ronron>
            <input
              :disabled="!logged"
              v-model="caque.liked"
              type="checkbox"
              @change="ronronnerPost(caque)"
              :id="`caque-` + caque.id_caque"
              class="btn-check"
              button
            />
            <label
              class="btn btn-outline-secondary"
              :for="`caque-` + caque.id_caque"
            >
              <img height="25" width="30" src="ronron.png" />{{
                caque.ronrons
              }}</label
            ><br />
          </template>
        </publication>
      </b-col>
    </b-row>
  </b-container>
</template>

<script>
var mois = {
  "01": "Jan.",
  "02": "Fev.",
  "03": "Mar.",
  "04": "Avr.",
  "05": "Mai",
  "06": "Juin",
  "07": "Jui.",
  "08": "Aout",
  "09": "Sep.",
  10: "Oct.",
  11: "Nov.",
  12: "Dec.",
};
import publication from "./Publication.vue";

const ADD_CAQUE = "http://localhost:8000/addCaque";
const GET_CAQUES = "http://localhost:8000/getCaques";
const LOGIN = "http://localhost:8000/connexion";
const LIKE = "http://localhost:8000/likeCaque";
const FOLLOWS = "http://localhost:8000/getFollows";
const FOLLOW = "http://localhost:8000/sendFollow";
const GET_PFP = "http://localhost:8000/getPfp";
const CHANGE_PFP = "http://localhost:8000/changePfp";

export default {
  name: "MainPage",
  data: function () {
    return {
      publicPath: process.env.BASE_URL,
      logged: false,
      user: "",
      nb_caques: 0,
      caques: [],
      ajout: "",
      rechercheuser: "",
      recherchetag: "",
      everyone: true,
      all: false,
      me: false,
      foll: false,
      followers: 0,
      followings: 0,
      ifollow: [],
      pfp: null,
      newpfp: null,
      blinks: false,
    };
  },
  methods: {
    // -------- AJOUTER UN CAQUE -------- //
    addFocus: function () {
      document.getElementById("caquer").focus();
    },
    addCaque: function () {
      if (this.ajout == "") {
        console.log("Le Caque ne peut être vide !");
      } else {
        const options = {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            id_user: this.$session.get("id_user"),
            message: this.ajout,
          }),
        };
        // On l'envoie
        fetch(ADD_CAQUE, options)
          .then((res) => res.json())
          .then((res) => {
            if (res.ok) {
              //Puis on l'ajoute au tableau pour la "session" en cours
              this.caques.unshift({
                id_caque: this.nb_caques + 1,
                ronrons: 0,
                caque: this.ajout,
                user: this.$session.get("user"),
                id_user: this.$session.get("id_user"),
                date_pub: new Date().toISOString(),
                hashtags: this.getHashtags(this.ajout),
                mentions: this.getMentions(this.ajout),
                liked: false,
              });
              this.nb_caques += 1;
              this.showAll();
              this.ajout = "";
              this.blinks = false;
            }
          });
      }
    },
    // --------- SE CONNECTER/SE DÉCONNECTER ------- //
    login: function () {
      const options = {
        // On crée les options (méthode + type de données + body) à envoyer au serveur
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          user: this.user,
        }),
      };

      fetch(LOGIN, options)
        .then((res) => res.json())
        .then((res) => {
          if (res.ok) {
            // Si l'envoi s'est bien passé, on crée une session
            this.logged = true;
            this.$session.start();
            this.$session.set("user", res.res[0].pseudo);
            this.$session.set("id_user", res.res[0].id_user);
            this.user = "";
            this.getFollows();
          }
        });
      this.showEveryone();
    },
    logout: function () {
      this.$session.clear();
      this.$session.destroy();
      this.logged = false;
      this.ifollow = [];
      this.all = false;
      this.me = false;
      this.foll = false;
      this.everyone = true;
      this.caques = [];
      this.nb_caques = 0;
    },
    // --- INTERACTION AVEC LES CAQUES ----------- //
    ronronnerPost(caque) {
      const options = {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          id_user: this.$session.get("id_user"),
          id_caque: caque.id_caque,
          ronronned: caque.liked,
        }),
      };
      fetch(LIKE, options)
        .then((res) => res.json())
        .then((res) => {
          if (res.ok) {
            if (caque.liked) {
              caque.ronrons++;
            } else {
              caque.ronrons--;
            }
          }
        });
    },
    sendFollow(caque) {
      fetch(FOLLOW, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          id_from: this.$session.get("id_user"),
          id_following: caque.id_user,
        }),
      })
        .then((res) => res.json())
        .then((res) => {
          if (res.ok) this.getFollows();
        });
      if (this.foll) {
        this.showFollowings();
      }
    },
    // --- RÉCUPÉRER LES DONNÉES ------------------//
    getCaques: function () {
      fetch(GET_CAQUES, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          nb_caques: this.nb_caques,
          id_user: this.$session.get("id_user"),
        }),
      })
        .then((res) => res.json())
        .then((res) => {
          if (res.ok) {
            for (var i = 0; i < res.res.caques.length; i++) {
              this.caques.unshift({
                id_user: res.res.caques[i].id_user,
                id_caque: res.res.caques[i].id_caque,
                ronrons: res.res.caques[i].nb_ronron,
                caque: res.res.caques[i].caque,
                user: res.res.caques[i].username,
                date_pub: res.res.caques[i].date,
                hashtags: this.getHashtags(res.res.caques[i].caque),
                mentions: this.getMentions(res.res.caques[i].caque),
                liked: false,
                photo: res.res.caques[i].photo,
              });
              this.showEveryone();
              if (this.logged) {
                this.hasInteracted(this.caques, res.res.reactions);
                if (this.caques[i].id_user == this.$session.get("id_user"))
                  this.pfp = this.caques[i].photo;
              }
              this.nb_caques++;
            }
            if (res.res.length > this.nb_caques)
              this.nb_caques = res.res.length;
            if (res.res.caques.length == 0) {
              if (!this.blinks) this.addOnClick();
            }
          } else throw res.err;
        });
    },
    getDate(date) {
      var year = date.substring(0, 4);
      var mon = date.substring(5, 7);
      var day;
      if (date.substring(8, 10).includes("T")) day = date.substring(8, 9);
      else day = date.substring(8, 10);
      return day + " " + mois[mon] + " " + year;
    },
    getHours(date) {
      return date.substring(11, 16);
    },
    getHashtags(texte) {
      let pattern = /(#[a-zA-Z]+)/g;
      let val = texte.match(pattern);
      return val !== null ? val : [];
    },
    getMentions(texte) {
      let pattern = /(@[^@#\s]+)/g;
      let val = texte.match(pattern);
      return val !== null ? val : [];
    },
    hasInteracted(caques, reactions) {
      for (var c = 0; c < caques.length; c++) {
        for (var r = 0; r < reactions.length; r++) {
          if (caques[c].id_caque == reactions[r].id_caque) {
            caques[c].liked = reactions[r].ronron;
          }
        }
      }
    },
    getFollows() {
      fetch(FOLLOWS, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          id_user: this.$session.get("id_user"),
        }),
      })
        .then((res) => res.json())
        .then((res) => {
          if (res.ok) {
            this.followers = res.nombre[0].abonne;
            this.followings = res.id_abonnements.length;
            this.ifollow = [];
            for (var p = 0; p < res.id_abonnements.length; p++) {
              this.ifollow.push(res.id_abonnements[p].id_abonnement);
            }
            for (var c = 0; c < this.caques.length; c++) {
              this.caques[c].following = this.ifollow.includes(
                this.caques[c].id_user
              );
            }
          }
        });
    },
    getPfp(caque) {
      fetch(GET_PFP, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          username: caque.user,
        }),
      })
        .then((res) => res.json())
        .then((res) => {
          if (res.ok) {
            caque.photo = res.pp[0].photo;
            this.pfp = res.pp[0].photo;
          }
        });
    },
    setDefaultImg(event) {
      event.target.src = "/pictures/default.png";
    },
    changePfp() {
      let formData = new FormData();
      formData.append("id_user", this.$session.get("id_user"));
      formData.append("newPP", this.newpfp);

      fetch(CHANGE_PFP, {
        method: "POST",
        body: formData,
      }).then((res) => res.json());
    },
    // ---------- AFFICHAGE DES CAQUES --------- //
    showEveryone() {
      if (this.rechercheuser == "") {
        for (var i = 0; i < this.caques.length; i++) {
          if (this.caques[i].mentions.includes("@everyone")) {
            this.caques[i].visible = this.everyone || this.all;
          }
        }
      }
    },
    showAll() {
      for (var i = 0; i < this.caques.length; i++) {
        this.caques[i].visible = this.all;
      }
      if (this.all) {
        this.rechercheuser = "";
        this.recherchetag = "";
      }
      if (this.me) this.showMe();
      if (this.everyone) this.showEveryone();
      if (this.foll) this.showFollowings();
    },
    showFollowings() {
      if (this.rechercheuser == "") {
        for (var c = 0; c < this.caques.length; c++) {
          if (this.ifollow.includes(this.caques[c].id_user))
            this.caques[c].visible = this.foll || this.all;
        }
      }
    },
    showMe() {
      if (this.rechercheuser == "") {
        for (var i = 0; i < this.caques.length; i++) {
          if (
            this.caques[i].mentions.includes("@" + this.$session.get("user"))
          ) {
            this.caques[i].visible = this.all || this.me;
          }
        }
      }
    },
    searchUser(usearch) {
      if (this.rechercheuser != "") {
        if (
          this.rechercheuser.toLowerCase() != "@everyone" &&
          this.rechercheuser.toLowerCase() != "everyone"
        ) {
          for (var i = 0; i < this.caques.length; i++) {
            this.caques[i].visible =
              usearch.toLowerCase() ==
              this.caques[i].user.substring(0, usearch.length).toLowerCase();
          }
        } else {
          this.rechercheuser = "";
          this.everyone = true;
          this.showEveryone();
        }
      } else this.showAll();
    },

    searchTag() {
      if (this.recherchetag != "") {
        for (var i = 0; i < this.caques.length; i++) {
          if (this.recherchetag.includes("#"))
            this.caques[i].visible =
              this.caques[i].hashtags.includes(this.recherchetag) || this.all;
          else
            this.caques[i].visible =
              this.caques[i].hashtags.includes("#" + this.recherchetag) ||
              this.all;
        }
      } else this.searchUser(this.rechercheuser);
    },
    addOnClick() {
      let mentions = document.getElementsByClassName("mention");
      let tags = document.getElementsByClassName("hash");
      let th = this;
      for (let m of mentions) {
        m.onclick = function () {
          window.scrollTo({
            top: 0,
            behavior: "smooth",
          });
          th.rechercheuser = m.innerText.slice(1);
          th.searchUser(th.rechercheuser);
        };
      }
      for (let t of tags) {
        t.onclick = function () {
          window.scrollTo({
            top: 0,
            behavior: "smooth",
          });
          th.all = false;
          th.recherchetag = t.innerText;
          th.searchTag();
        };
      }
      this.blinks = true;
    },
  },
  components: {
    publication,
  },
  mounted() {
    setInterval(() => {
      this.getCaques();
      this.getFollows();
    }, 400);

    setInterval(() => {
      fetch("http://localhost:8000/purgeDB", {}).then((res) => res.json());
    }, 10000);
    this.showEveryone();
  },
  created: function () {
    if (this.$session.exists()) {
      this.logged = true;
      this.getFollows();
    }
  },
  computed: {
    console: () => console,
  },
};
</script>

<style>
#maincontainer {
  text-align: left;
}
#nav-header {
  border-bottom: 1px solid lightgrey;
}

#usettingssort {
  position: sticky;
  top: 0px;
  padding: 10px 0px;
}

#maincolumn {
  border-left: 1px solid lightgray;
}

.pfp {
  border-radius: 50px;
  border: 2px solid rgb(250, 191, 113);
  height: 10%;
  width: 7%;
  transition: all 0.2s;
}

.pfp:hover {
  cursor: pointer;
  border: 2px solid rgb(88, 176, 235);
}

#userpfp {
  height: 100%;
  width: 50%;
  border-radius: 8px;
  border: 3px solid rgb(250, 191, 113);
}

.hash {
  color: rgb(119, 196, 241);
  text-decoration: underline;
  transition: all 0.2s;
}

.hash:hover {
  color: rgb(32, 52, 145);
  cursor: pointer;
}

.caquser,
.mention {
  text-decoration: none;
  text-transform: uppercase;
  color: rgb(185, 38, 38);
  transition: all 0.2s;
}

.rep {
  text-align: center;
  border-radius: 6px;
  border: 1px solid lightgrey;
  cursor: pointer;
  background: none;
  transition: all 0.2s;
}

.rep:hover {
  background: rgb(41, 41, 41);
  color: lightgrey;
}

.caquser:hover,
.mention:hover {
  color: rgb(105, 44, 44);
  cursor: pointer;
}
</style>
